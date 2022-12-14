# frozen_string_literal: true

require "sentry-ruby"
require "sentry-rails"
require "sentry-sidekiq"

Sentry.init do |config|
  config.enabled_environments = ["production"]
  config.release = "dependabot-gitlab@#{ENV['APP_VERSION']}"
  config.skip_rake_integration = true
  config.logger = DependabotLogger.logger(source: "sentry", logdev: :file)
  config.traces_sample_rate = AppConfig.sentry_traces_sample_rate
  config.excluded_exceptions += AppConfig.sentry_ignored_errors if AppConfig.sentry_ignored_errors
end
