import { Module } from '@nestjs/common'
import { TypeOrmModule } from '@nestjs/typeorm'
import { TrashStory } from './story.entity'
import { TrashJoinApply } from './apply.entity'
import { TrashSiteConfig } from './config.entity'
import { TrashStoriesService } from './stories.service'
import { TrashAppliesService } from './applies.service'
import { TrashConfigService } from './config.service'
import { TrashStoriesController, TrashAppliesController, TrashConfigController } from './controller'
import { TrashPublicController } from './public.controller'

@Module({
  imports: [TypeOrmModule.forFeature([TrashStory, TrashJoinApply, TrashSiteConfig])],
  controllers: [
    TrashStoriesController,
    TrashAppliesController,
    TrashConfigController,
    TrashPublicController,
  ],
  providers: [TrashStoriesService, TrashAppliesService, TrashConfigService],
})
export class TrashModule {}
