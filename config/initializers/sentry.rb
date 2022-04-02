# frozen_string_literal: true

require "sentry-ruby"
require "sentry-rails"
require "sentry-sidekiq"

Sentry.init do |config|
  config.enabled_environments = ["production"]
  config.release = "dependabot-gitlab@#{ENV['APP_VERSION']}"
  config.skip_rake_integration = true
  config.logger = DependabotLogger.logger("sentry")
  config.traces_sample_rate = AppConfig.sentry_traces_sample_rate
end
