import { IsNotEmpty, MaxLength } from 'class-validator'
import { BaseEntity, BaseColumn, MyEntity, boolNumColumn } from 'src/common/entity/BaseEntity'
import { Column } from 'typeorm'
import { BoolNum } from 'src/common/type/base'

@MyEntity('trash_story')
export class TrashStory extends BaseEntity {
  constructor(obj = {}) {
    super()
    this.assignOwn(obj)
  }

  @BaseColumn({ comment: '标签，如：前教培从业者', length: 30 })
  @IsNotEmpty()
  @MaxLength(30)
  tag: string

  @BaseColumn({ comment: '标签颜色', length: 10, default: '#c68642' })
  tagColor: string

  @BaseColumn({ comment: '头像颜色', length: 10, default: '#d49a5c' })
  avatarColor: string

  @BaseColumn({ comment: '头像文字（姓氏）', length: 2 })
  avatarLetter: string

  @BaseColumn({ comment: '故事标题', length: 100 })
  @IsNotEmpty()
  @MaxLength(100)
  title: string

  @BaseColumn({ type: 'text', comment: '引用语/故事内容' })
  @IsNotEmpty()
  quote: string

  @BaseColumn({ comment: '姓名', length: 20 })
  @IsNotEmpty()
  @MaxLength(20)
  name: string

  @BaseColumn({ comment: '加入时长文字', length: 30 })
  duration: string

  @BaseColumn({ comment: '配图URL', length: 500 })
  image: string

  @BaseColumn({ type: 'int', default: 0, comment: '排序，数字越小越靠前' })
  order: number

  @BaseColumn(boolNumColumn('激活', 'is_active', BoolNum.Yes))
  isActive: BoolNum
}
