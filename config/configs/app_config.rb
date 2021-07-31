# frozen_string_literal: true

class AppConfig < ApplicationConfig
  env_prefix :settings_

  attr_config :dependabot_url,
              gitlab_url: "https://gitlab.com",
              standalone: false,
              log_level: "info",
              # mr command prefix
              commands_prefix: "$dependabot",
              # update job retry amount
              update_retry: 2,
              # config file
              config_filename: ".gitlab/dependabot.yml",
              config_branch: nil,
              # /metrics endpoint
              metrics: true,
              # project registration
              project_registration: "manual",
              project_registration_cron: "0 5 * * *"

  # Configurable sidekiq retry
  #
  # @return [Numeric, Boolean]
  def sidekiq_retry
    update_retry.is_a?(Numeric) ? update_retry : update_retry == "true"
  end
end
