import { Injectable } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { Repository } from 'typeorm'
import { TrashSiteConfig } from './config.entity'
import { TrashSiteConfigDto } from './dto'
import { BaseService } from 'src/common/BaseService'

@Injectable()
export class TrashConfigService extends BaseService<TrashSiteConfig, TrashSiteConfigDto> {
  constructor(
    @InjectRepository(TrashSiteConfig)
    repository: Repository<TrashSiteConfig>,
  ) {
    super(TrashSiteConfig, repository)
  }

  async getConfig(): Promise<TrashSiteConfig> {
    let config = await this.repository.findOne({ where: {} })
    if (!config) {
      config = await this.repository.save(new TrashSiteConfig())
    }
    return config
  }

  async saveConfig(dto: TrashSiteConfigDto): Promise<TrashSiteConfig> {
    const existing = await this.repository.findOne({ where: {} })
    if (existing) {
      dto.id = existing.id
    }
    return this.save(dto)
  }
}
