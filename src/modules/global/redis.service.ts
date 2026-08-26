import { Injectable, Logger, OnModuleInit } from '@nestjs/common'
import { Redis } from 'ioredis'
import { LoginLogsService } from '../loginLogs/service'
import { QueryListDto } from 'src/common/dto'
import { MenusService } from '../menus/menus.service'
import { MenuType } from '../menus/menu.entity'
import { BoolNum } from 'src/common/type/base'

@Injectable()
export class RedisService implements OnModuleInit {
  redis: Redis
  private useMemory = false
  private memoryStore = new Map<string, { value: string; expireAt: number }>()
  private readonly logger = new Logger(RedisService.name)

  constructor(
    private loginLogsService: LoginLogsService,
    private menusService: MenusService,
  ) {
    this.redis = new Redis({
      port: 6379,
      host: '127.0.0.1',
      db: 1,
      lazyConnect: true,
      retryStrategy: () => null, // 不重试
      connectTimeout: 3000,
    })
  }

  async onModuleInit() {
    try {
      await this.redis.connect()
      this.logger.log('Redis 连接成功')
    } catch {
      this.logger.warn('Redis 未连接，使用内存存储降级方案')
      this.useMemory = true
    }
  }

  async set(key: string, value: any, time?: number) {
    if (value && typeof value === 'object') {
      value = JSON.stringify(value)
    }
    if (this.useMemory) {
      this.memoryStore.set(key, { value: value as string, expireAt: time ? Date.now() + time * 1000 : 0 })
      return 'OK'
    }
    return await (time ? this.redis.set(key, value, 'EX', time) : this.redis.set(key, value))
  }

  async get(key: string) {
    if (this.useMemory) {
      const item = this.memoryStore.get(key)
      if (!item) return null
      if (item.expireAt && item.expireAt < Date.now()) {
        this.memoryStore.delete(key)
        return null
      }
      return item.value
    }
    return await this.redis.get(key)
  }

  async del(key: string) {
    if (this.useMemory) {
      this.memoryStore.delete(key)
      return 1
    }
    return await this.redis.del(key)
  }

  async ttl(key: string) {
    if (this.useMemory) {
      const item = this.memoryStore.get(key)
      if (!item || !item.expireAt) return -1
      const ttl = Math.ceil((item.expireAt - Date.now()) / 1000)
      return ttl > 0 ? ttl : -2
    }
    return await this.redis.ttl(key)
  }

  async keys(pattern: string) {
    if (this.useMemory) {
      const regex = new RegExp('^' + pattern.replace(/\*/g, '.*') + '$')
      return Array.from(this.memoryStore.keys()).filter((k) => regex.test(k))
    }
    return await this.redis.keys(pattern)
  }

  async expire(key: string, time: number) {
    if (this.useMemory) {
      const item = this.memoryStore.get(key)
      if (item) {
        item.expireAt = Date.now() + time * 1000
        return 1
      }
      return 0
    }
    return await this.redis.expire(key, time)
  }

  async exists(key: string) {
    if (this.useMemory) {
      return this.memoryStore.has(key) ? 1 : 0
    }
    return await this.redis.exists(key)
  }

  async hset(key: string, field: string, value: string) {
    if (this.useMemory) {
      let hash = this.memoryStore.get(key)
      let data: Record<string, string> = {}
      if (hash) {
        try { data = JSON.parse(hash.value) } catch {}
      }
      data[field] = value
      this.memoryStore.set(key, { value: JSON.stringify(data), expireAt: hash?.expireAt || 0 })
      return 1
    }
    return await this.redis.hset(key, field, value)
  }

  async hget(key: string, field: string) {
    if (this.useMemory) {
      const hash = this.memoryStore.get(key)
      if (!hash) return null
      try {
        const data = JSON.parse(hash.value)
        return data[field] || null
      } catch {
        return null
      }
    }
    return await this.redis.hget(key, field)
  }

  async hdel(key: string, field: string) {
    if (this.useMemory) {
      const hash = this.memoryStore.get(key)
      if (!hash) return 0
      try {
        const data = JSON.parse(hash.value)
        delete data[field]
        this.memoryStore.set(key, { value: JSON.stringify(data), expireAt: hash.expireAt })
        return 1
      } catch {
        return 0
      }
    }
    return await this.redis.hdel(key, field)
  }

  // getNotExpiredKeys
  async getNotExpiredValues(pattern = '*'): Promise<{}[]> {
    if (this.useMemory) {
      const regex = new RegExp('^' + pattern.replace(/\*/g, '.*') + '$')
      const notExpiredKeys = []
      for (const [key, item] of this.memoryStore.entries()) {
        if (regex.test(key)) {
          if (item.expireAt && item.expireAt < Date.now()) {
            this.memoryStore.delete(key)
            continue
          }
          try {
            notExpiredKeys.push(JSON.parse(item.value))
          } catch {
            notExpiredKeys.push(item.value)
          }
        }
      }
      return notExpiredKeys
    }

    let cursor = '0'
    const notExpiredKeys = []

    while (true) {
      const [newCursor, keys] = await this.redis.scan(cursor, 'MATCH', pattern, 'COUNT', 100)
      cursor = newCursor

      for (const key of keys) {
        const ttl = await this.ttl(key)
        if (ttl > 0) {
          let value = await this.get(key)
          notExpiredKeys.push(JSON.parse(value))
        }
      }

      if (cursor === '0') {
        break
      }
    }
    return notExpiredKeys
  }

  async getRedisOnlineUser(query: QueryListDto = {}) {
    let data: any[] = await this.getNotExpiredValues('user.online:*')
    data = data.filter((item) => {
      return (
        (!query.createTimeRange?.[0] ||
          (+new Date(item.createTime) >= +new Date(query.createTimeRange[0]) &&
            +new Date(item.createTime) <= +new Date(this.loginLogsService.dateToEndTime(query.createTimeRange[1])))) &&
        (!query.account || item.account.includes(query.account)) &&
        (!query.ip || item.ip.includes(query.ip)) &&
        (!query.address || item.address.includes(query.address))
      )
    })
    let { pageNum, pageSize } = query
    return [data.slice(--pageNum * pageSize, pageSize), data.length]
  }

  async setRedisOnlineUser(reqOrData, user: any = {}) {
    if (reqOrData.session) {
      return await this.set(`user.online:${reqOrData?.session}`, reqOrData, 5 * 60)
    } else {
      let log = await this.loginLogsService.createLog(reqOrData, user, false)
      return await this.set(`user.online:${user?.session}`, log, 5 * 60)
    }
  }

  async delRedisOnlineUser(session) {
    return await this.del(`user.online:${session}`)
  }

  // 获取权限列表
  async getPermissions(): Promise<[string]> {
    let data: string | any = await this.get('permissions')
    data &&= JSON.parse(data)
    if (!data) {
      let menus = await this.menusService.list({ isActive: BoolNum.Yes, type: MenuType.button }, false)
      data = menus.flatMap((e) => e.permissionKey || [])
      await this.set('permissions', data)
    }
    return data
  }
}
