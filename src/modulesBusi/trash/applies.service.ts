import { Injectable } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { Repository } from 'typeorm'
import { TrashJoinApply, ApplyStatus } from './apply.entity'
import { TrashJoinApplyDto } from './dto'
import { BaseService } from 'src/common/BaseService'
import { QueryListDto, ResponseListDto } from 'src/common/dto'
import { validate } from 'class-validator'
import { HttpException } from '@nestjs/common'

@Injectable()
export class TrashAppliesService extends BaseService<TrashJoinApply, TrashJoinApplyDto> {
  constructor(@InjectRepository(TrashJoinApply) repository: Repository<TrashJoinApply>) {
    super(TrashJoinApply, repository)
  }

  async list(query: QueryListDto): Promise<ResponseListDto<TrashJoinApply>> {
    const { name, phone, status } = query
    const where: any = {}
    if (name) where.name = this.sqlLike(name)
    if (phone) where.phone = this.sqlLike(phone)
    if (status !== undefined && status !== '') where.status = status
    return this.listBy({ where, order: { createTime: 'DESC' } }, query)
  }

  async submitApply(body: TrashJoinApplyDto) {
    const entity = new TrashJoinApply(body)
    entity.status = ApplyStatus.pending
    entity.createUser = '官网用户'
    entity.createUserId = '0'
    const errors = await validate(entity, { skipMissingProperties: true })
    if (errors.length > 0) {
      throw new HttpException(Object.values(errors[0].constraints)[0], 400)
    }
    return this.repository.save(entity)
  }
}
