import { PartialType } from '@nestjs/mapped-types'
import { TrashStory } from './story.entity'
import { TrashJoinApply } from './apply.entity'
import { TrashSiteConfig } from './config.entity'

export class TrashStoryDto extends PartialType(TrashStory) {}
export class TrashJoinApplyDto extends PartialType(TrashJoinApply) {}
export class TrashSiteConfigDto extends PartialType(TrashSiteConfig) {}
