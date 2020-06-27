# frozen_string_literal: true

return unless Rails.env.production?

require "sentry-raven"

Raven.configure do |config|
  config.environments = ["production"]
end
