import { Controller, Get, Post, Body, Req } from '@nestjs/common'
import { FamilyMembersService, RelationType } from './members.service'
import { FamilyMember } from './member.entity'
import { BaseController } from 'src/common/BaseController'
import { Request } from 'express'

// 家族成员管理(后台)
@Controller('business/family/members')
export class FamilyMembersController extends BaseController<FamilyMember, FamilyMembersService> {
  constructor(readonly service: FamilyMembersService) {
    super(service)
  }

  // ------- 以登录账号为中心 -------

  /**
   * 当前登录人是否是家族成员? (用 sys_user.phone 匹配 family_member.phone)
   * 返回 { isMember: boolean, member?: {...} }
   */
  @Get('me')
  async getCurrentMember(@Req() req: Request) {
    const phone = (req as any).user?.phone
    if (!phone) return { isMember: false }
    const member = await this.service.getCurrentMemberByPhone(phone)
    if (!member) return { isMember: false }
    // 返回精简数据(避免暴露多余字段)
    return {
      isMember: true,
      member: {
        id: member.id,
        name: member.name,
        gender: member.gender,
        phone: member.phone,
        birth: member.birth,
        city: member.city,
      },
    }
  }

  /**
   * 计算 mainMemberId 与族谱中每个人的亲属关系
   * 返回 { mainId, relations: { [memberId]: '称呼' } }
   * 只有调用 /me 拿到 isMember=true 时才应该用
   */
  @Get('relations')
  async getRelations(@Req() req: Request) {
    const mainMemberId = (req.query as any).mainMemberId as string
    if (!mainMemberId) return { mainId: null, relations: {} }

    const result = await this.service.computeRelations(mainMemberId)
    // Map → object
    const relations: Record<string, string> = {}
    for (const [k, v] of result) relations[k] = v
    return { mainId: mainMemberId, relations }
  }

  // 成员地区分布(中国地图用)
  @Get('getMemberAreaList')
  async getMemberAreaList() {
    return this.service.getMemberAreaList()
  }

  // 成员统计
  @Get('getMemberStats')
  async getMemberStats() {
    return this.service.getMemberStats()
  }

  // 绑定亲属关系
  @Post('bindRelation')
  async bindRelation(@Body() body: { personAId: string; personBId: string; relation: RelationType }) {
    return this.service.bindRelation(body.personAId, body.personBId, body.relation)
  }

  // 族谱树(按 fatherId 递归构建,配偶挂 spouse 字段)
  @Get('getFamilyTree')
  async getFamilyTree() {
    return this.service.getFamilyTree()
  }
}
