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
    Rainbow.enabled = AppConfig.log_color

    config.load_defaults 7.0
    config.active_job.queue_adapter = :sidekiq

    logger = DependabotLogger
             .logger(source: "dependabot")
             .extend(ActiveSupport::Logger.broadcast(DependabotLogger.db_logger))

    config.logger = logger
    config.log_level = AppConfig.log_level
    config.mongoid.logger = DependabotLogger.logger(source: "mongodb", logdev: :file)

    config.after_initialize do
      if Sidekiq.server?
        require "sidekiq_alive"

        SidekiqAlive.setup do |config|
          config.path = "/healthcheck"
          config.custom_liveness_probe = proc { Mongoid.default_client.database_names.present? }
          config.time_to_live = 60
        end

        Dependabot::Projects::Registration::JobCreator.call
        Github::Vulnerabilities::UpdateJobCreator.call
      end
    end
  end
end
