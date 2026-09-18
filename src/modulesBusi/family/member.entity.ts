import { IsNotEmpty, MaxLength } from 'class-validator'
import { BaseEntity, BaseColumn, MyEntity, boolNumColumn } from 'src/common/entity/BaseEntity'
import { BoolNum } from 'src/common/type/base'

@MyEntity('family_member')
export class FamilyMember extends BaseEntity {
  constructor(obj = {}) {
    super()
    this.assignOwn(obj)
  }

  @BaseColumn({ comment: '姓名', length: 20 })
  @IsNotEmpty()
  @MaxLength(20)
  name: string

  @BaseColumn({ comment: '曾用名', length: 20, nullable: true })
  formerName: string

  @BaseColumn({ comment: '性别: 1男 0女', type: 'tinyint', default: 1 })
  gender: number

  @BaseColumn({ comment: '所在城市', length: 50 })
  city: string

  @BaseColumn({ comment: '出生地', length: 50 })
  birthplace: string

  @BaseColumn({ comment: '手机号', length: 20 })
  phone: string

  @BaseColumn({ comment: '头像', length: 500 })
  avatar: string

  @BaseColumn({ comment: '父节点ID(族谱用,兼容旧数据)', type: 'bigint', nullable: true })
  parentId: string

  @BaseColumn({ comment: '父亲ID', type: 'bigint', nullable: true })
  fatherId: string

  @BaseColumn({ comment: '母亲ID', type: 'bigint', nullable: true })
  motherId: string

  @BaseColumn({ comment: '配偶ID', type: 'bigint', nullable: true })
  spouseId: string

  @BaseColumn({ comment: '世代(相对世代,基准代可自定义,允许负数)', type: 'int', nullable: true })
  generation: number

  @BaseColumn({ comment: '出生年月', type: 'date', nullable: true })
  birth: string

  @BaseColumn({ comment: '逝世年月', type: 'date', nullable: true })
  death: string

  @BaseColumn({ comment: '备注', length: 500, nullable: true })
  remark: string

  @BaseColumn(boolNumColumn('激活', 'is_active', BoolNum.Yes))
  isActive: BoolNum
}
