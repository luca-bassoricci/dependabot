# frozen_string_literal: true

require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_view/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require_relative "log_formatter"

module DependabotGitlab
  class Application < Rails::Application
    config.load_defaults 6.0
    config.active_job.queue_adapter = :sidekiq

    logger = Logger.new(STDOUT)
    logger.formatter = ::SimpleLogFormatter.new
    logger.datetime_format = DATETIME_FORMAT

    tagged_logger = ActiveSupport::TaggedLogging.new(logger)
    config.logger = tagged_logger
    config.mongoid.logger = tagged_logger

    config.anyway_config.default_config_path = lambda { |name|
      Rails.root.join("#{ENV['APP_CONFIG'] || 'config'}/#{name}.yml")
    }
  end
end
