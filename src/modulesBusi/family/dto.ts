import { PartialType } from '@nestjs/mapped-types'
import { FamilyMember } from './member.entity'

export class FamilyMemberDto extends PartialType(FamilyMember) {}
