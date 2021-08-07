# frozen_string_literal: true

class DependabotConfig < ApplicationConfig
  env_prefix :settings_

  attr_config :config_branch,
              branch_name_separator: "-",
              open_pull_request_limit: 5,
              config_filename: ".gitlab/dependabot.yml"
end