# frozen_string_literal: true

require "sentry-ruby"
require "sentry-rails"
require "sentry-sidekiq"

Sentry.init do |config|
  config.enabled_environments = ["production"]
  config.release = "dependabot-gitlab@#{ENV['VERSION']}"
  config.skip_rake_integration = true
  config.logger = DependabotLogger.logger
  config.traces_sampler = lambda do |sampling_context|
    transaction_context = sampling_context[:transaction_context]
    op = transaction_context[:op]
    transaction_name = transaction_context[:name]

    case op
    when /request/
      case transaction_name
      when /healthcheck/
        0.0
      else
        1.0
      end
    when /sidekiq/
      1.0
    else
      0.0
    end
  end
end
