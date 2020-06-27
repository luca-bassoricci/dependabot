# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require_relative "log_formatter"

module DependabotGitlab
  class Application < Rails::Application
    config.load_defaults 6.0
    config.active_job.queue_adapter = :sidekiq

    config.logger = Logger.new(STDOUT)
    config.logger.formatter = ::SimpleLogFormatter.new
    config.logger.datetime_format = DATETIME_FORMAT
    config.log_level = ENV["LOG_LEVEL"]&.to_sym || :info
  end
end
