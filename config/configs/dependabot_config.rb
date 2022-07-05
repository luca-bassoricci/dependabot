# frozen_string_literal: true

class DependabotConfig < ApplicationConfig
  env_prefix :settings_

  attr_config :config_branch,
              :config_base_filename,
              branch_name_separator: "-",
              open_pull_request_limit: 5,
              config_filename: ".gitlab/dependabot.yml"

  def branch_name_separator
    if ENV["SETTINGS__BRANCH_NAME_SEPARATOR"]
      ApplicationHelper.log(
        :warn,
        "Setting branch name separator via environment variable is deprecated, please use global configuration file!"
      )
    end

    super
  end

  def open_pull_request_limit
    if ENV["SETTINGS__OPEN_PULL_REQUEST_LIMIT"]
      ApplicationHelper.log(
        :warn,
        "Setting open pull request limit via environment variable is deprecated, please use global configuration file!"
      )
    end

    super
  end
end
