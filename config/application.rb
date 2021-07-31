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

require_relative "dependabot_logger"

module DependabotGitlab
  class Application < Rails::Application
    config.load_defaults 6.0
    config.active_job.queue_adapter = :sidekiq

    DependabotLogger.logger.tap do |logger|
      config.logger = logger
      config.mongoid.logger = logger
      config.log_level = AppConfig.log_level
    end

    config.anyway_config.default_config_path = lambda { |name|
      Rails.root.join("#{ENV['APP_CONFIG'] || 'config'}/#{name}.yml")
    }

    config.after_initialize do
      Dependabot::ProjectRegistration.call if Sidekiq.server?
    end
  end
end
