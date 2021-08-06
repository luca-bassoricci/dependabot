# frozen_string_literal: true

class AppConfig < ApplicationConfig
  env_prefix :settings_

  attr_config :dependabot_url,
              gitlab_url: "https://gitlab.com",
              standalone: false,
              log_level: "info",
              create_project_hook: true,
              # mr command prefix
              commands_prefix: "$dependabot",
              # update job retry amount
              update_retry: 2,
              # /metrics endpoint
              metrics: true,
              # project registration
              project_registration: "automatic",
              project_registration_cron: "0/5 * * * *",
              project_registration_namespace: nil

  # Configurable sidekiq retry
  #
  # @return [Numeric, Boolean]
  def sidekiq_retry
    update_retry.is_a?(Numeric) ? update_retry : update_retry == "true"
  end
end
