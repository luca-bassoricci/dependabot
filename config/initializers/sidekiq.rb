# frozen_string_literal: true

require_relative "../log_formatter"

Sidekiq.configure_server do |config|
  config.log_formatter = SimpleLogFormatter.new
  config.logger.datetime_format = DATETIME_FORMAT
  config.redis = { password: ENV["REDIS_PASSWORD"] } if ENV["REDIS_PASSWORD"]
end

Sidekiq.configure_client do |config|
  config.redis = { password: ENV["REDIS_PASSWORD"] } if ENV["REDIS_PASSWORD"]
end

Redis.exists_returns_integer = true
