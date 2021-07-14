# frozen_string_literal: true

# Credentials configuration
#
class CredentialsConfig < ApplicationConfig
  env_prefix :settings_

  attr_config :gitlab_access_token,
              :github_access_token,
              :gitlab_auth_token

  required :gitlab_access_token
end
