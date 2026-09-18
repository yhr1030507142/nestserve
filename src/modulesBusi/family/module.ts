import { Module } from '@nestjs/common'
import { TypeOrmModule } from '@nestjs/typeorm'
import { FamilyMember } from './member.entity'
import { FamilyMembersService } from './members.service'
import { FamilyMembersController } from './controller'

@Module({
  imports: [TypeOrmModule.forFeature([FamilyMember])],
  controllers: [FamilyMembersController],
  providers: [FamilyMembersService],
})
export class FamilyModule {}
