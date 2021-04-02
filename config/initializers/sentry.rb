# frozen_string_literal: true

return if ENV["SIDEKIQ_HEALTHCHECK"]

require "sentry-ruby"
require "sentry-rails"
require "sentry-sidekiq"

Sentry.init do |config|
  config.enabled_environments = ["production"]
  config.traces_sample_rate = 0.5
end
