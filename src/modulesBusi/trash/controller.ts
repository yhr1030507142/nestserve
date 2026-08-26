import { Controller, Get, Post, Body, Req } from '@nestjs/common'
import { TrashStoriesService } from './stories.service'
import { TrashAppliesService } from './applies.service'
import { TrashConfigService } from './config.service'
import { BaseController } from 'src/common/BaseController'
import { TrashStory } from './story.entity'
import { TrashJoinApply } from './apply.entity'
import { TrashSiteConfig } from './config.entity'
import { TrashSiteConfigDto } from './dto'
import { config } from 'config'

// 故事管理（后台）
@Controller('business/trash/stories')
export class TrashStoriesController extends BaseController<TrashStory, TrashStoriesService> {
  constructor(readonly service: TrashStoriesService) {
    super(service)
  }
}

// 申请列表管理（后台）
@Controller('business/trash/applies')
export class TrashAppliesController extends BaseController<TrashJoinApply, TrashAppliesService> {
  constructor(readonly service: TrashAppliesService) {
    super(service)
  }
}

// 站点配置管理（后台）
@Controller('business/trash/config')
export class TrashConfigController {
  constructor(private readonly configService: TrashConfigService) {}

  @Get('get')
  async get() {
    return this.configService.getConfig()
  }

  @Post('save')
  async save(@Body() body: TrashSiteConfigDto, @Req() req) {
    if (body.id) {
      body.updateUser = req.user.name
    } else {
      body.createUser = req.user.name
      body.createUserId = req.user.id
    }
    body[config.reqUserId] = req?.user?.id
    return this.configService.saveConfig(body)
  }
}
