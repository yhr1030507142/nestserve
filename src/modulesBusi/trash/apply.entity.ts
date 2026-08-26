import { IsNotEmpty } from 'class-validator'
import { BaseEntity, BaseColumn, MyEntity, boolNumColumn } from 'src/common/entity/BaseEntity'
import { BoolNum } from 'src/common/type/base'

export enum ApplyStatus {
  pending = '0',
  contacted = '1',
  matched = '2',
  rejected = '3',
}
export const applyStatusMap = {
  [ApplyStatus.pending]: '待处理',
  [ApplyStatus.contacted]: '已联系',
  [ApplyStatus.matched]: '已匹配',
  [ApplyStatus.rejected]: '已拒绝',
}

@MyEntity('trash_join_apply')
export class TrashJoinApply extends BaseEntity {
  constructor(obj = {}) {
    super()
    this.assignOwn(obj)
  }

  // 基本信息
  @BaseColumn({ comment: '姓名', length: 20 })
  @IsNotEmpty()
  name: string

  @BaseColumn({ comment: '联系电话', length: 20 })
  @IsNotEmpty()
  phone: string

  @BaseColumn({ comment: '微信号', length: 50 })
  wechat: string

  @BaseColumn({ comment: '当前所在城市', length: 50 })
  city: string

  // 出生信息
  @BaseColumn({ comment: '出生日期', length: 20, name: 'birth_date' })
  birthDate: string

  @BaseColumn({ comment: '出生时辰', length: 30, name: 'birth_time' })
  birthTime: string

  @BaseColumn({ comment: '出生地', length: 100, name: 'birth_place' })
  birthPlace: string

  // 技能与经历
  @BaseColumn({ type: 'text', comment: '过往职业经历' })
  experience: string

  @BaseColumn({ type: 'text', comment: '擅长技能' })
  skills: string

  @BaseColumn({ type: 'text', comment: '希望探索的方向' })
  direction: string

  @BaseColumn({ type: 'enum', enum: ApplyStatus, default: ApplyStatus.pending, comment: '申请状态' })
  status: ApplyStatus

  @BaseColumn({ type: 'text', nullable: true, comment: '管理员备注' })
  remark: string
}
