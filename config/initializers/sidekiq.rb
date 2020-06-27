# frozen_string_literal: true

require_relative "../log_formatter"

Sidekiq.configure_server do |config|
  config.log_formatter = SidekiqLogFormatter.new
  config.logger.datetime_format = DATETIME_FORMAT
end
