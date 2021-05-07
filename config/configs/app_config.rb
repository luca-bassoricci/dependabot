# frozen_string_literal: true

class AppConfig < ApplicationConfig
  env_prefix :settings_

  attr_config :dependabot_url,
              gitlab_url: "https://gitlab.com",
              config_filename: ".gitlab/dependabot.yml",
              standalone: false,
              log_level: "info",
              commands_prefix: "$dependabot"
end
