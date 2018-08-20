require 'redis'
require 'redis-namespace'
require 'redis/objects'
redis_cfg = Rails.application.config_for(:redis)

redis = Redis.new(host: redis_cfg['host'], port: redis_cfg['port'], driver: :hiredis)
redis.select(redis_cfg['db'])
Redis::Objects.redis = redis
Redis.current = redis

sidekiq_url = "redis://#{redis_cfg['host']}:#{redis_cfg['port']}/#{redis_cfg['db_sidekiq']}"
Sidekiq.configure_server do |config|
  config.redis = { url: sidekiq_url, namespace: redis_cfg['ns_sidekiq'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: sidekiq_url, namespace: redis_cfg['ns_sidekiq'] }
end

# class Redis::Namespace
#   def delete_all_keys
#     keys = self.keys '*'
#     self.del keys if keys.present?
#   end
# end
