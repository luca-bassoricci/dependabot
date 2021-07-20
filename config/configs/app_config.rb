# frozen_string_literal: true

class AppConfig < ApplicationConfig
  env_prefix :settings_

  attr_config :dependabot_url,
              gitlab_url: "https://gitlab.com",
              config_filename: ".gitlab/dependabot.yml",
              config_branch: nil,
              standalone: false,
              log_level: "info",
              commands_prefix: "$dependabot",
              update_retry: 2

  # Configurable sidekiq retry
  #
  # @return [Numeric, Boolean]
  def sidekiq_retry
    update_retry.is_a?(Numeric) ? update_retry : update_retry == "true"
  end
end
