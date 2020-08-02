# frozen_string_literal: true

require "sentry-raven"

Raven.configure do |config|
  config.environments = ["production"]
end
