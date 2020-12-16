# frozen_string_literal: true

redis_conf = {
  password: ENV["REDIS_PASSWORD"],
  timeout: 1,
  reconnect_attempts: 3
}

Sidekiq.configure_server do |config|
  config.options[:queues].push(HealthcheckConfig.queue)
  config.redis = redis_conf
end
Sidekiq.configure_client do |config|
  config.redis = redis_conf
end

Redis.exists_returns_integer = true

# Reduce verbose output of activejob
ActiveJob::Base.logger = Logger.new(IO::NULL)
