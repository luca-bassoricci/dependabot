# frozen_string_literal: true

return if ENV["SIDEKIQ_HEALTHCHECK"]

require "sentry-raven"

Raven.configure do |config|
  config.environments = ["production"]
end
