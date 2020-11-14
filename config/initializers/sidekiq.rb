# frozen_string_literal: true

require_relative "../log_formatter"

redis_config = {
  password: ENV["REDIS_PASSWORD"],
  reconnect_attempts: 5,
  reconnect_delay: 2,
  reconnect_delay_max: 10.0
}

Sidekiq.configure_server do |config|
  config.log_formatter = SimpleLogFormatter.new
  config.logger.datetime_format = DATETIME_FORMAT
  config.redis = redis_config
end

Sidekiq.configure_client { |config| config.redis = redis_config }

Redis.exists_returns_integer = true
