// ============================================================================
// 亲属称谓引擎(纯函数,无框架依赖,可独立测试)
// 输入: 以 main 为中心的家族图(fatherId/motherId/spouseId 边)
// 输出: main 与族谱中每个人的中文亲属称谓
//
// 算法:
//  1. Dijkstra 求每个人到 main 的最短"关系路径"(血亲边权重1,配偶边1.5 →
//     优先血亲路径,禁止连续配偶边)
//  2. 按路径形状(前缀配偶 + 向上a步 + 向下d步 + 后缀配偶)映射中文称谓,
//     全程用真实 gender 取称谓(母亲绝不会显示成父亲)
//  3. 未覆盖的罕见路径用"锚点称谓的X"组合兜底,保证族谱里人人有称谓
// ============================================================================

export interface KinPerson {
  id: string
  name?: string
  gender?: number // 1男 0女
  fatherId?: string | null
  motherId?: string | null
  spouseId?: string | null
  birth?: string | Date | null
}

type Tok = 'F' | 'M' | 'C' | 'S' // up-father / up-mother / down-child / spouse
interface Step {
  tok: Tok
  person: KinPerson
}

const W_BLOOD = 1
const W_SPOUSE = 1.5

/** 获取某人的所有孩子 id */
function childrenOf(id: string, persons: KinPerson[]): string[] {
  const out: string[] = []
  for (const p of persons) {
    if (p.fatherId === id || p.motherId === id) out.push(p.id)
  }
  return out
}

/** 取姓别字符串 */
const isMale = (p: KinPerson) => p.gender === 1

/** 年龄比较: a 比 b 年长返回 1, 年幼返回 -1, 未知返回 0 */
function olderThan(a: KinPerson, b: KinPerson): number {
  if (!a?.birth || !b?.birth) return 0
  const da = new Date(a.birth).getTime()
  const db = new Date(b.birth).getTime()
  if (isNaN(da) || isNaN(db) || da === db) return 0
  return da < db ? 1 : -1 // 出生早 = 年长
}

// ---- 基础称谓表 ----
const ANCESTOR_M = ['', '父亲', '祖父', '曾祖父', '高祖父', '天祖父', '烈祖父', '太祖父', '远祖父']
const ANCESTOR_F = ['', '母亲', '祖母', '曾祖母', '高祖母', '天祖母', '烈祖母', '太祖母', '远祖母']
const DESC_M = ['', '儿子', '孙子', '曾孙', '玄孙', '来孙', '晜孙', '仍孙', '云孙', '耳孙']
const DESC_F = ['', '女儿', '孙女', '曾孙女', '玄孙女', '来孙女', '晜孙女', '仍孙女', '云孙女', '耳孙女']

/** 直系祖先称谓: k=1..8, maternal=母系加"外" */
function ancestorTitle(k: number, male: boolean, maternal: boolean): string {
  const base = male ? ANCESTOR_M[k] : ANCESTOR_F[k]
  if (!base) return male ? '先祖' : '先祖'
  if (maternal && k >= 2) return '外' + base
  return base
}

/** 直系后代称谓: k=1..9 */
function descendantTitle(k: number, male: boolean): string {
  const t = male ? DESC_M[k] : DESC_F[k]
  return t || (male ? '后代' : '后代')
}

function spouseWord(male: boolean): string {
  return male ? '丈夫' : '妻子'
}

function parentWord(male: boolean): string {
  return male ? '父亲' : '母亲'
}

function childWord(male: boolean): string {
  return male ? '儿子' : '女儿'
}

/** 兄弟姐妹称谓(按出生日期分长幼,未知时默认兄/姐) */
function siblingTitle(main: KinPerson, target: KinPerson): string {
  const older = olderThan(target, main)
  if (isMale(target)) return older === -1 ? '弟弟' : '哥哥'
  return older === -1 ? '妹妹' : '姐姐'
}

/**
 * 称谓主函数: main 经 steps 到达 target
 * people[i] = 第 i 步到达的人 (people[0] = main)
 */
function titleOf(main: KinPerson, steps: Step[], people: KinPerson[]): string {
  const target = people[people.length - 1]

  // ---- 剥离前缀配偶(姻亲入口) ----
  let leadSpouse: KinPerson | null = null
  let rest = steps
  let restPeople = people
  if (steps.length && steps[0].tok === 'S') {
    leadSpouse = steps[0].person
    rest = steps.slice(1)
    restPeople = people.slice(1)
  }

  // ---- 1. 纯配偶 ----
  if (leadSpouse && rest.length === 0) return spouseWord(isMale(target))

  // ---- 2. 血亲路径分析: 向上a步 + 向下d步 + 可选后缀配偶 ----
  let ups: Step[] = []
  let downs: Step[] = []
  let tailSpouse = false
  let shapeOk = true
  {
    let i = 0
    while (i < rest.length && (rest[i].tok === 'F' || rest[i].tok === 'M')) ups.push(rest[i++])
    while (i < rest.length && rest[i].tok === 'C') downs.push(rest[i++])
    if (i < rest.length && rest[i].tok === 'S') {
      tailSpouse = true
      i++
    }
    if (i !== rest.length) shapeOk = false // 形状不符(如 C 后又 F)
  }
  const a = ups.length
  const d = downs.length
  // 母系判定: 第一个向上步走的是母亲
  const maternal = a > 0 && ups[0].tok === 'M'

  // ---- 2.1 纯祖先 ----
  if (shapeOk && leadSpouse === null && a > 0 && d === 0 && !tailSpouse) {
    return ancestorTitle(a, isMale(target), maternal)
  }

  // ---- 2.2 纯后代 ----
  if (shapeOk && leadSpouse === null && a === 0 && d > 0 && !tailSpouse) {
    return descendantTitle(d, isMale(target))
  }

  // ---- 2.3 后代的配偶(儿媳/女婿等) ----
  if (shapeOk && leadSpouse === null && a === 0 && d > 0 && tailSpouse) {
    if (d === 1) return isMale(target) ? '女婿' : '儿媳'
    if (d === 2) return isMale(target) ? '孙女婿' : '孙儿媳'
    return `${descendantTitle(d, isMale(target))}的${spouseWord(isMale(target))}`
  }

  // ---- 2.4 旁系血亲(有上有下) ----
  if (shapeOk && leadSpouse === null && a > 0 && d > 0 && !tailSpouse) {
    // 锚点 = 第一个"向下"步到达的人(共同祖先的直接晚辈)
    const anchor = people[a] // ups 之后第一步步到的人

    if (a === 1) {
      if (d === 1) return siblingTitle(main, target)
      if (d === 2) {
        // 兄弟姐妹的孩子: 兄弟的孩子=侄, 姐妹的孩子=甥
        if (isMale(anchor)) return isMale(target) ? '侄子' : '侄女'
        return isMale(target) ? '外甥' : '外甥女'
      }
      if (d === 3) {
        if (isMale(anchor)) return isMale(target) ? '侄孙' : '侄孙女'
        return isMale(target) ? '甥孙' : '甥孙女'
      }
      // 更深: 组合兜底
      return `${siblingTitle(main, anchor)}的${descendantTitle(d - 1, isMale(target))}`
    }

    if (a === 2) {
      if (d === 1) {
        // 父母亲的兄弟姐妹: 叔伯/姑/舅/姨
        if (maternal) return isMale(target) ? '舅舅' : '姨妈'
        return isMale(target) ? '叔伯' : '姑姑'
      }
      if (d === 2) {
        // 堂/表兄弟姐妹: 锚点为父/母的兄弟姐妹
        const isTang = !maternal && isMale(anchor) // 父亲的兄弟的孩子=堂
        if (isTang) return isMale(target) ? '堂兄弟' : '堂姐妹'
        return isMale(target) ? '表兄弟' : '表姐妹'
      }
      if (d === 3) return isMale(target) ? '表侄' : '表侄女'
      // 更深: 组合兜底
      const prefix = titleOf(main, steps.slice(0, a + d - 1), people.slice(0, a + d))
      return `${prefix}的${childWord(isMale(target))}`
    }

    if (a === 3 && d === 1) {
      // 祖辈的兄弟姐妹
      if (maternal) return isMale(target) ? '舅祖父' : '姨祖母'
      return isMale(target) ? '叔祖父' : '姑祖母'
    }

    if (a === d && a >= 3) {
      // 同辈远亲
      return isMale(target) ? '远房兄弟' : '远房姐妹'
    }

    // 通用兜底: 去掉最后一步递归 + 的儿子/女儿
    const prefix = titleOf(main, steps.slice(0, steps.length - 1), people.slice(0, people.length - 1))
    return `${prefix}的${childWord(isMale(target))}`
  }

  // ---- 2.5 旁系 + 后缀配偶(伯母/姑父/嫂子等) ----
  if (shapeOk && leadSpouse === null && a > 0 && d > 0 && tailSpouse) {
    if (a === 1 && d === 1) {
      // 兄弟姐妹的配偶: 兄嫂/弟妹, 姐夫/妹夫
      const anchor = people[1] // 兄弟/姐妹
      const olderAnchor = olderThan(anchor, main)
      if (isMale(anchor)) return olderAnchor === -1 ? '弟妹' : '嫂嫂'
      return olderAnchor === -1 ? '妹夫' : '姐夫'
    }
    if (a === 2 && d === 1) {
      // 父母的兄弟姐妹的配偶
      const anchor = people[2]
      if (maternal) return isMale(anchor) ? '舅母' : '姨父'
      return isMale(anchor) ? '伯母/婶母' : '姑父'
    }
    // 通用: 锚点称谓 + 的丈夫/妻子
    const prefix = titleOf(main, steps.slice(0, steps.length - 1), people.slice(0, people.length - 1))
    return `${prefix}的${spouseWord(isMale(target))}`
  }

  // ---- 3. 姻亲路径(经过配偶) ----
  if (leadSpouse) {
    const spPrefix = isMale(leadSpouse) ? '丈夫的' : '妻子的'

    // 配偶的直系父母: 岳父岳母 / 公公婆婆
    if (shapeOk && a === 1 && d === 0 && !tailSpouse) {
      if (isMale(main)) return isMale(target) ? '岳父' : '岳母'
      return isMale(target) ? '公公' : '婆婆'
    }
    // 配偶的孩子: 继子/继女
    if (shapeOk && a === 0 && d > 0 && !tailSpouse) {
      if (d === 1) return isMale(target) ? '继子' : '继女'
      if (d === 2) return isMale(target) ? '继孙' : '继孙女'
      return `${spPrefix}${descendantTitle(d, isMale(target))}`
    }
    // 配偶的兄弟姐妹: 内兄/内弟 等,简化为 称谓组合
    if (shapeOk && a === 1 && d === 1 && !tailSpouse) {
      if (isMale(main)) {
        // 妻子那边的: 内兄/内弟/内姐/内妹 → 通俗化
        return isMale(target) ? '内兄/内弟' : '内姐/内妹'
      }
      // 丈夫那边的: 大伯子/小叔子/大姑子/小姑子 → 通俗化
      return isMale(target) ? '伯兄/叔兄' : '姑姐/姑妹'
    }
    // 其余姻亲: 递归算相对配偶的称谓再加前缀
    const sub = titleOf(leadSpouse, rest, restPeople)
    return `${spPrefix}${sub}`
  }

  // ---- 4. 形状不符的极罕见路径: 逐步组合 ----
  const prefix = titleOf(main, steps.slice(0, steps.length - 1), people.slice(0, people.length - 1))
  const last = steps[steps.length - 1]
  const roleWord = last.tok === 'C' ? childWord(isMale(target)) : last.tok === 'S' ? spouseWord(isMale(target)) : parentWord(isMale(target))
  return `${prefix}的${roleWord}`
}

/**
 * 计算族谱中所有人相对 main 的称谓
 * @returns Map<memberId, 称谓> (含 main 自己 = '我')
 */
export function computeKinships(mainId: string, persons: KinPerson[]): Map<string, string> {
  const result = new Map<string, string>()
  const byId = new Map<string, KinPerson>()
  for (const p of persons) byId.set(p.id, p)
  const main = byId.get(mainId)
  if (!main) return result
  result.set(mainId, '我')

  // ---- Dijkstra: cost 最小, 其次配偶边最少(权重已体现) ----
  const dist = new Map<string, { cost: number; steps: Step[]; people: KinPerson[] }>()
  dist.set(mainId, { cost: 0, steps: [], people: [main] })
  const visited = new Set<string>()

  const expand = (id: string, state: { cost: number; steps: Step[]; people: KinPerson[] }) => {
    const cur = byId.get(id)
    if (!cur) return
    const lastTok = state.steps.length ? state.steps[state.steps.length - 1].tok : null

    const push = (tok: Tok, nextId: string | null | undefined, weight: number) => {
      if (!nextId) return
      const next = byId.get(nextId)
      if (!next || visited.has(nextId)) return
      // 禁止连续配偶边
      if (tok === 'S' && lastTok === 'S') return
      const cost = state.cost + weight
      const old = dist.get(nextId)
      if (!old || cost < old.cost - 1e-9) {
        dist.set(nextId, {
          cost,
          steps: [...state.steps, { tok, person: next }],
          people: [...state.people, next],
        })
      }
    }

    push('F', cur.fatherId, W_BLOOD)
    push('M', cur.motherId, W_BLOOD)
    push('S', cur.spouseId, W_SPOUSE)
    // 反向配偶(对方指向我)
    for (const p of persons) {
      if (p.spouseId === id && p.id !== cur.spouseId) push('S', p.id, W_SPOUSE)
    }
    for (const cid of childrenOf(id, persons)) push('C', cid, W_BLOOD)
  }

  // 简单 Dijkstra(数据量小,数组扫描即可)
  while (visited.size < persons.length) {
    let bestId: string | null = null
    let bestCost = Infinity
    for (const [id, st] of dist) {
      if (!visited.has(id) && st.cost < bestCost) {
        bestCost = st.cost
        bestId = id
      }
    }
    if (bestId === null) break
    visited.add(bestId)
    expand(bestId, dist.get(bestId)!)
  }

  for (const [id, st] of dist) {
    if (id === mainId) continue
    if (!visited.has(id)) continue
    try {
      const title = titleOf(main, st.steps, st.people)
      if (title) result.set(id, title)
    } catch (e) {
      // 兜底不抛错
      result.set(id, '亲属')
    }
  }
  return result
}
