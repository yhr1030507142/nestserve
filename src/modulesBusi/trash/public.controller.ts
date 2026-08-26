import { Controller, Get, Post, Body } from '@nestjs/common'
import { TrashStoriesService } from './stories.service'
import { TrashAppliesService } from './applies.service'
import { TrashConfigService } from './config.service'
import { Public } from 'src/modules/auth/auth.service'
import { TrashJoinApplyDto } from './dto'

// 官网公开接口（无需登录）
@Public()
@Controller('public/trash')
export class TrashPublicController {
  constructor(
    private readonly storiesService: TrashStoriesService,
    private readonly appliesService: TrashAppliesService,
    private readonly configService: TrashConfigService,
  ) {}

  @Get('config')
  async getConfig() {
    return this.configService.getConfig()
  }

  @Get('stories')
  async getStories() {
    return this.storiesService.findActive()
  }

  @Post('apply')
  async submitApply(@Body() body: TrashJoinApplyDto) {
    return this.appliesService.submitApply(body)
  }
}
