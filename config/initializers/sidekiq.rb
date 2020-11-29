# frozen_string_literal: true

require_relative "../log_formatter"

redis_config = {
  password: ENV["REDIS_PASSWORD"],
  timeout: 1,
  reconnect_attempts: 3
}

Sidekiq.configure_server do |config|
  config.log_formatter = SimpleLogFormatter.new
  config.logger.datetime_format = DATETIME_FORMAT
  config.redis = redis_config
  config.options[:queues].push("default", Settings.sidekiq_healthcheck_queue)
end
Sidekiq.configure_client { |config| config.redis = redis_config }

Redis.exists_returns_integer = true
