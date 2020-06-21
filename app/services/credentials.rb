# frozen_string_literal: true

class Credentials < ApplicationService
  # Get credentials
  # @return [Array<Hash>]
  def call
    Rails.cache.fetch("credentials") { [github_credentials, gitlab_credentials].compact }
  end

  private

  def github_credentials
    token = Settings.github_access_token
    return unless token

    {
      "type" => "git_source",
      "host" => "github.com",
      "username" => "x-access-token",
      "password" => token
    }
  end

  def gitlab_credentials
    token = Settings.gitlab_access_token
    raise StandardError, "Missing environment variable SETTINGS_GITLAB_ACCESS_TOKEN" unless token

    {
      "type" => "git_source",
      "host" => Settings.gitlab_hostname,
      "username" => "x-access-token",
      "password" => token
    }
  end
end
