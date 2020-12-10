# frozen_string_literal: true

Redis.exists_returns_integer = true

Sidekiq.tap do |sidekiq|
  sidekiq.logger = DependabotLogger.logger
  sidekiq.options[:queues].push(HealthcheckConfig.queue)
  sidekiq.redis = {
    password: ENV["REDIS_PASSWORD"],
    timeout: 1,
    reconnect_attempts: 3
  }
end

# Reduce verbose output of activejob
ActiveJob::Base.logger = Logger.new(IO::NULL)
