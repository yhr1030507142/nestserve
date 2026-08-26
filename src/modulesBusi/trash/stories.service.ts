import { Injectable } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { Repository } from 'typeorm'
import { TrashStory } from './story.entity'
import { TrashStoryDto } from './dto'
import { BaseService } from 'src/common/BaseService'
import { QueryListDto, ResponseListDto } from 'src/common/dto'
import { BoolNum } from 'src/common/type/base'

@Injectable()
export class TrashStoriesService extends BaseService<TrashStory, TrashStoryDto> {
  constructor(@InjectRepository(TrashStory) repository: Repository<TrashStory>) {
    super(TrashStory, repository)
  }

  async list(query: QueryListDto): Promise<ResponseListDto<TrashStory>> {
    const { title, isActive } = query
    const where: any = {}
    if (title) where.title = this.sqlLike(title)
    if (isActive !== undefined && isActive !== '') where.isActive = isActive
    return this.listBy({ where, order: { order: 'ASC', createTime: 'DESC' } }, query)
  }

  async findActive(): Promise<TrashStory[]> {
    return this.repository.find({
      where: { isActive: BoolNum.Yes },
      order: { order: 'ASC', createTime: 'DESC' },
    })
  }
}
