import { IsOptional } from 'class-validator'
import { BaseEntity, BaseColumn, MyEntity } from 'src/common/entity/BaseEntity'

@MyEntity('trash_site_config')
export class TrashSiteConfig extends BaseEntity {
  constructor(obj = {}) {
    super()
    this.assignOwn(obj)
  }

  // Hero 区
  @IsOptional()
  @BaseColumn({ length: 50, default: '已有 1,247 位伙伴在这里重新出发', comment: 'Hero徽章文字' })
  heroBadge: string

  @IsOptional()
  @BaseColumn({ length: 50, default: '失业不是终点', comment: 'Hero标题第一行' })
  heroTitle1: string

  @IsOptional()
  @BaseColumn({ length: 50, default: '是重新认识自己', comment: 'Hero标题第二行强调部分' })
  heroTitle2Accent: string

  @IsOptional()
  @BaseColumn({ length: 50, default: '的开始', comment: 'Hero标题第二行后续' })
  heroTitle2: string

  @IsOptional()
  @BaseColumn({ type: 'text', comment: 'Hero描述文字' })
  heroDesc: string

  @IsOptional()
  @BaseColumn({ length: 200, comment: 'Hero背景图URL' })
  heroBg: string

  @IsOptional()
  @BaseColumn({ length: 20, default: '来自各行各业的伙伴', comment: '伙伴描述文字' })
  heroPartnersText: string

  // About 区
  @IsOptional()
  @BaseColumn({ type: 'text', comment: 'About描述段落1' })
  aboutP1: string

  @IsOptional()
  @BaseColumn({ type: 'text', comment: 'About描述段落2' })
  aboutP2: string

  @IsOptional()
  @BaseColumn({ type: 'text', comment: 'About描述段落3' })
  aboutP3: string

  @IsOptional()
  @BaseColumn({ length: 200, comment: 'About右侧图片' })
  aboutImage: string

  @IsOptional()
  @BaseColumn({ length: 20, default: '1,247', comment: '统计数字1' })
  statValue1: string

  @IsOptional()
  @BaseColumn({ length: 20, default: '社区成员', comment: '统计标签1' })
  statLabel1: string

  @IsOptional()
  @BaseColumn({ length: 20, default: '86', comment: '统计数字2' })
  statValue2: string

  @IsOptional()
  @BaseColumn({ length: 20, default: '成功组队', comment: '统计标签2' })
  statLabel2: string

  @IsOptional()
  @BaseColumn({ length: 20, default: '34', comment: '统计数字3' })
  statValue3: string

  @IsOptional()
  @BaseColumn({ length: 20, default: '创业项目', comment: '统计标签3' })
  statLabel3: string

  // Process 区
  @IsOptional()
  @BaseColumn({ length: 100, default: '我们不卖课程，不推销机会。只是帮你找到对的人，一起做点有意义的事。', comment: '运作方式副标题' })
  processSubtitle: string

  @IsOptional()
  @BaseColumn({ length: 50, default: '提交你的信息', comment: '步骤1标题' })
  step1Title: string

  @IsOptional()
  @BaseColumn({ type: 'text', comment: '步骤1描述' })
  step1Desc: string

  @IsOptional()
  @BaseColumn({ length: 30, default: '约 5 分钟完成', comment: '步骤1标签' })
  step1Meta: string

  @IsOptional()
  @BaseColumn({ length: 50, default: '等待分组匹配', comment: '步骤2标题' })
  step2Title: string

  @IsOptional()
  @BaseColumn({ type: 'text', comment: '步骤2描述' })
  step2Desc: string

  @IsOptional()
  @BaseColumn({ length: 30, default: '平均 3-7 天匹配', comment: '步骤2标签' })
  step2Meta: string

  @IsOptional()
  @BaseColumn({ length: 50, default: '开始探索', comment: '步骤3标题' })
  step3Title: string

  @IsOptional()
  @BaseColumn({ type: 'text', comment: '步骤3描述' })
  step3Desc: string

  @IsOptional()
  @BaseColumn({ length: 30, default: '持续跟进支持', comment: '步骤3标签' })
  step3Meta: string

  // Footer
  @IsOptional()
  @BaseColumn({ length: 200, default: '没有真正的垃圾，只有放错位置的资源。', comment: 'Footer口号' })
  footerSlogan: string

  @IsOptional()
  @BaseColumn({ length: 200, default: '帮助被裁员的30+人才找到合适的伙伴，重新出发。', comment: 'Footer描述' })
  footerDesc: string

  @IsOptional()
  @BaseColumn({ length: 200, default: '让每一个被丢弃的人才，找到新的归属', comment: 'Footer底部备注' })
  footerNote: string

  @IsOptional()
  @BaseColumn({ length: 100, default: 'hello@trash.center', comment: '联系邮箱' })
  contactEmail: string

  @IsOptional()
  @BaseColumn({ length: 100, default: 'TrashCenter2024', comment: '微信号' })
  contactWechat: string
}