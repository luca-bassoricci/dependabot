# frozen_string_literal: true

return if ENV["SIDEKIQ_HEALTHCHECK"]

require "sentry-ruby"
require "sentry-rails"
require "sentry-sidekiq"

Sentry.init do |config|
  config.enabled_environments = ["production"]
  config.release = "dependabot-gitlab@#{ENV['VERSION']}"
  config.skip_rake_integration = true
  config.logger = DependabotLogger.logger
  config.traces_sample_rate = 0.3
end
