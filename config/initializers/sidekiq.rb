# frozen_string_literal: true

redis_config = {
  password: ENV["REDIS_PASSWORD"],
  timeout: 1,
  reconnect_attempts: 3
}
Redis.exists_returns_integer = true

Sidekiq.configure_server do |config|
  config.logger = DependabotLogger.logger
  config.redis = redis_config
  config.options[:queues].push("default", HealthcheckConfig.queue)
end
Sidekiq.configure_client { |config| config.redis = redis_config }

# Reduce verbose output of activejob
ActiveJob::Base.logger = Logger.new(IO::NULL)
