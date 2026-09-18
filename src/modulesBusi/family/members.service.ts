import { Injectable, BadRequestException } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { Repository, DataSource } from 'typeorm'
import { FamilyMember } from './member.entity'
import { FamilyMemberDto } from './dto'
import { BaseService } from 'src/common/BaseService'
import { QueryListDto, ResponseListDto } from 'src/common/dto'
import { BoolNum } from 'src/common/type/base'
import { computeKinships, KinPerson } from './relation.util'

export type RelationType = 'father' | 'mother' | 'spouse' | 'son' | 'daughter'

@Injectable()
export class FamilyMembersService extends BaseService<FamilyMember, FamilyMemberDto> {
  constructor(
    @InjectRepository(FamilyMember) repository: Repository<FamilyMember>,
    private dataSource: DataSource,
  ) {
    super(FamilyMember, repository)
  }

  // ============================================================================
  // 以登录账号为中心的亲属关系功能
  // ============================================================================

  /**
   * 根据手机号查找当前登录人对应的家族成员(账号匹配)
   */
  async getCurrentMemberByPhone(phone: string): Promise<FamilyMember | null> {
    if (!phone) return null
    return this.repository.findOne({
      where: { phone, isDelete: undefined },
    })
  }

  /**
   * 计算 mainMemberId 与族谱中每个人的亲属关系(中文称呼)
   * 核心逻辑在 relation.util.ts(纯函数引擎):
   *  - 覆盖族谱里所有人: 直系/旁系(兄弟姐妹、叔伯姑舅姨、堂表、侄甥)/姻亲
   *  - 称谓一律按真实 gender 取(母亲绝不会显示成父亲)
   */
  async computeRelations(mainMemberId: string): Promise<Map<string, string>> {
    const all = await this.repository.find({ where: { isDelete: undefined } })
    if (!all.length) return new Map()

    const persons: KinPerson[] = all.map((m) => ({
      id: m.id,
      name: m.name,
      gender: m.gender,
      fatherId: m.fatherId,
      motherId: m.motherId,
      spouseId: m.spouseId,
      birth: m.birth,
    }))
    return computeKinships(mainMemberId, persons)
  }

  // ============================================================================
  // 族谱树(按 fatherId 递归构建,配偶挂 spouse 字段)

  async list(query: QueryListDto): Promise<ResponseListDto<FamilyMember>> {
    const { name, phone, city, gender, isActive } = query
    const where: any = { isDelete: undefined }
    if (name) where.name = this.sqlLike(name)
    if (phone) where.phone = this.sqlLike(phone)
    if (city) where.city = this.sqlLike(city)
    if (gender !== undefined && gender !== '') where.gender = gender
    if (isActive !== undefined && isActive !== '') where.isActive = isActive
    return this.listBy({ where, order: { createTime: 'DESC' } }, query)
  }

  // 成员地区分布聚合查询,按省份分组(取 city 字段的第一段,如"广东省/深圳市/南山区"→"广东省")
  // 返回 [{name: 省份, value: 数量}],供中国地图按省份前两位匹配渲染热力色阶
  async getMemberAreaList(): Promise<{ name: string; value: number }[]> {
    const rows = await this.repository
      .createQueryBuilder('m')
      // city 存储格式如"广东省/深圳市/南山区",SUBSTRING_INDEX 取第一段作为省份
      .select("SUBSTRING_INDEX(m.city, '/', 1)", 'name')
      .addSelect('COUNT(*)', 'value')
      .where('m.is_active = :active', { active: BoolNum.Yes })
      .andWhere('m.is_delete IS NULL')
      .andWhere('m.city IS NOT NULL')
      .andWhere("m.city != ''")
      .groupBy("SUBSTRING_INDEX(m.city, '/', 1)")
      .orderBy('COUNT(*)', 'DESC')
      .getRawMany()
    return rows.map((r) => ({ name: r.name, value: +r.value }))
  }

  // 统计:总成员数 / 男 / 女 / 覆盖城市数
  async getMemberStats(): Promise<{ total: number; male: number; female: number; cityCount: number }> {
    const total = await this.repository.count({ where: { isActive: BoolNum.Yes } })
    const genderRows = await this.repository
      .createQueryBuilder('m')
      .select('m.gender', 'gender')
      .addSelect('COUNT(*)', 'value')
      .where('m.is_active = :active', { active: BoolNum.Yes })
      .andWhere('m.is_delete IS NULL')
      .groupBy('m.gender')
      .orderBy('COUNT(*)', 'DESC')
      .getRawMany()
    let male = 0,
      female = 0
    for (const r of genderRows) {
      if (+r.gender === 1) male = +r.value
      else female = +r.value
    }
    const cityCount = await this.repository
      .createQueryBuilder('m')
      .select('COUNT(DISTINCT m.city)', 'cnt')
      .where('m.is_active = :active', { active: BoolNum.Yes })
      .andWhere('m.is_delete IS NULL')
      .orderBy('COUNT(DISTINCT m.city)', 'DESC')
      .getRawOne()
    return { total, male, female, cityCount: +cityCount?.cnt || 0 }
  }

  /**
   * 绑定亲属关系(事务,支持跨记录更新)
   * @param personAId  人员A(当前选中行)
   * @param personBId  人员B(下拉选择的另一个成员)
   * @param relation   B 相对 A 的关系类型
   */
  async bindRelation(personAId: string, personBId: string, relation: RelationType) {
    if (personAId === personBId) {
      throw new BadRequestException('不能绑定自己')
    }

    return this.dataSource.transaction(async (manager) => {
      const aRepo = manager.getRepository(FamilyMember)
      const personA = await aRepo.findOne({ where: { id: personAId } })
      const personB = await aRepo.findOne({ where: { id: personBId } })
      if (!personA) throw new BadRequestException('人员A不存在')
      if (!personB) throw new BadRequestException('人员B不存在')

      // 循环引用校验:如果 B 已是 A 的祖先,不能再绑定为后代
      // 比如 A.fatherId = B, 则 B.fatherId = A 就是循环
      if (relation === 'father' || relation === 'mother') {
        const isDesc = await this.isDescendant(personA, personB, aRepo)
        console.log(`[bindRelation] 循环引用校验: personA(${personA.id},${personA.name}) personB(${personB.id},${personB.name}) relation=${relation} isDescendant=${isDesc}`)
        if (isDesc) {
          throw new BadRequestException('循环引用:B 已经是 A 的后代,不能再绑定为 A 的长辈')
        }
      }
      if (relation === 'spouse') {
        // 配偶:检查 A 或 B 是否已有配偶,同时双向绑定
        if (personA.spouseId && personA.spouseId !== personBId) {
          throw new BadRequestException(`${personA.name} 已有配偶`)
        }
        if (personB.spouseId && personB.spouseId !== personAId) {
          throw new BadRequestException(`${personB.name} 已有配偶`)
        }
        personA.spouseId = personBId
        personB.spouseId = personAId
        await aRepo.save([personA, personB])
        return { success: true }
      }

      // 性别校验: 父/子 要求 B 是男性, 母/女 要求 B 是女性(防止母亲被写成父亲)
      if ((relation === 'father' || relation === 'son') && personB.gender !== 1) {
        throw new BadRequestException(`${personB.name} 的性别是女性,不能绑定为${relation === 'father' ? '父亲' : '儿子'}`)
      }
      if ((relation === 'mother' || relation === 'daughter') && personB.gender !== 0) {
        throw new BadRequestException(`${personB.name} 的性别是男性,不能绑定为${relation === 'mother' ? '母亲' : '女儿'}`)
      }

      switch (relation) {
        case 'father':
          personA.fatherId = personBId
          personA.parentId = personBId // 兼容旧字段
          await aRepo.save(personA)
          break
        case 'mother':
          personA.motherId = personBId
          await aRepo.save(personA)
          break
        case 'son':
        case 'daughter':
          // A 是父/母,B 是子女: 按 A 的真实性别写 fatherId / motherId
          // (之前写死 fatherId 导致女性被当成父亲,族谱和称谓全错)
          if (personA.gender === 0) {
            personB.motherId = personAId
          } else {
            personB.fatherId = personAId
          }
          personB.parentId = personAId // 兼容旧字段
          await aRepo.save(personB)
          break
      }
      return { success: true }
    })
  }

  /**
   * 判断 descendant 是否是 ancestor 的后代(沿 fatherId 链向上找)
   * 防止循环引用:A 是 B 的父亲,B 又是 A 的父亲
   */
  private async isDescendant(
    ancestor: FamilyMember,
    descendant: FamilyMember,
    repo: Repository<FamilyMember>,
  ): Promise<boolean> {
    let curId: string | null = descendant.id
    const visited = new Set<string>()
    // 沿 descendant 的 fatherId 链向上爬,如果爬到 ancestor,说明 descendant 是 ancestor 的后代
    while (curId && !visited.has(curId)) {
      visited.add(curId)
      if (curId === ancestor.id) return true
      const cur = await repo.findOne({ where: { id: curId } })
      curId = cur?.fatherId || null
    }
    return false
  }

  /**
   * 构建族谱树 - FamilyUnit 结构(夫妻单元 + 子女递归)
   * 每个 FamilyUnit = { husband(男), wife(女), children: FamilyUnit[] }
   * 如果只有一人没有配偶,则 husband 或 wife 为 null
   * 子女按 fatherId 归属,自动并入有配偶一方的 FamilyUnit
   */
  async getFamilyTree(): Promise<any[]> {
    const all = await this.repository.find({ where: { isDelete: undefined } })
    if (!all.length) return []

    const map = new Map<string, any>()
    for (const m of all) {
      map.set(m.id, {
        id: m.id,
        name: m.name,
        formerName: m.formerName,
        gender: m.gender,
        generation: m.generation,
        birth: m.birth,
        death: m.death,
        city: m.city,
        birthplace: m.birthplace,
        phone: m.phone,
        avatar: m.avatar,
        remark: m.remark,
        fatherId: m.fatherId,
        motherId: m.motherId,
        spouseId: m.spouseId,
      })
    }

    // 构建"人 → FamilyUnit"映射,避免同一对夫妻创建两个 Unit
    const personToUnit = new Map<string, any>()
    // 记录哪些人已被某个 Unit 包含(防止重复)
    const usedPersons = new Set<string>()

    const makePerson = (p: any) => ({ ...p })

    // 从一个人出发创建/获取 FamilyUnit
    const getOrCreateUnit = (personId: string): any => {
      if (personToUnit.has(personId)) return personToUnit.get(personId)
      const p = map.get(personId)
      if (!p) return null

      const unit: any = {
        husband: null,
        wife: null,
        children: [] as any[],
      }
      // 根据性别分配(1=男→husband, 0=女→wife)
      if (p.gender === 1) {
        unit.husband = makePerson(p)
      } else if (p.gender === 0) {
        unit.wife = makePerson(p)
      } else {
        // 性别未知,默认放到 husband
        unit.husband = makePerson(p)
      }

      // 尝试挂配偶
      if (p.spouseId && map.has(p.spouseId) && !usedPersons.has(p.spouseId)) {
        const sp = map.get(p.spouseId)
        if (sp.gender === 0) {
          unit.wife = makePerson(sp)
        } else if (sp.gender === 1) {
          unit.husband = makePerson(sp)
        } else {
          if (unit.husband && !unit.wife) unit.wife = makePerson(sp)
          else unit.husband = makePerson(sp)
        }
        usedPersons.add(sp.id)
        personToUnit.set(sp.id, unit)
      }

      usedPersons.add(p.id)
      personToUnit.set(p.id, unit)
      return unit
    }

    // 第一轮:为所有人创建/归属 FamilyUnit
    for (const p of map.values()) {
      if (!usedPersons.has(p.id)) {
        getOrCreateUnit(p.id)
      }
    }

    // 第二轮:按 fatherId 将子女 Unit 挂到父母 Unit 的 children 下
    for (const unit of personToUnit.values()) {
      // 确定父母双方的 id
      const parentIds: string[] = []
      if (unit.husband) parentIds.push(unit.husband.id)
      if (unit.wife) parentIds.push(unit.wife.id)

      for (const pid of parentIds) {
        const p = map.get(pid)
        if (p) {
          // 找此人的子女(fatherId 或 motherId 指向自己)
          for (const child of map.values()) {
            if (child.fatherId === pid || child.motherId === pid) {
              const childUnit = personToUnit.get(child.id)
              if (childUnit && !unit.children.includes(childUnit)) {
                unit.children.push(childUnit)
              }
            }
          }
        }
      }
    }

    // 第三轮:找根节点(没有父亲的人对应的 Unit)
    const roots: any[] = []
    const allUnitIds = new Set(personToUnit.values())
    const visitedUnits = new Set<any>()

    for (const unit of allUnitIds) {
      if (visitedUnits.has(unit)) continue
      // 找这个 Unit 中是否有成员没有父亲(即根)
      const hasRootMember = [unit.husband, unit.wife].some((m: any) => m && !m.fatherId)
      if (hasRootMember) {
        roots.push(unit)
        visitedUnits.add(unit)
        // 把它的后代都标记已访问
        const markDescendants = (u: any) => {
          visitedUnits.add(u)
          for (const c of u.children) markDescendants(c)
        }
        markDescendants(unit)
      }
    }

    // 如果没找到根(异常情况),把所有未访问的 Unit 也加进去
    for (const unit of allUnitIds) {
      if (!visitedUnits.has(unit)) roots.push(unit)
    }

    // 第四轮:按 generation 排序 children
    const getUnitGeneration = (u: any): number => {
      const gens = [u.husband?.generation, u.wife?.generation].filter((g) => g != null)
      return gens.length ? Math.min(...gens) : 0
    }
    const sortChildren = (arr: any[]) => {
      arr.sort((a, b) => getUnitGeneration(a) - getUnitGeneration(b))
      for (const c of arr) sortChildren(c.children)
    }
    sortChildren(roots)

    return roots
  }
}
