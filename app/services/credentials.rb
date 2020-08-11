# frozen_string_literal: true

class Credentials < ApplicationService
  # Get credentials
  # @return [Array<Hash>]
  def call
    [github_credentials, gitlab_credentials]
  end

  private

  def github_credentials
    @github_credentials ||= begin
      token = Settings.github_access_token
      raise StandardError, "Missing environment variable SETTINGS__GITHUB_ACCESS_TOKEN" unless token

      {
        "type" => "git_source",
        "host" => "github.com",
        "username" => "x-access-token",
        "password" => token
      }
    end
  end

  def gitlab_credentials
    @gitlab_credentials ||= begin
      token = Settings.gitlab_access_token
      raise StandardError, "Missing environment variable SETTINGS__GITLAB_ACCESS_TOKEN" unless token

      {
        "type" => "git_source",
        "host" => Settings.gitlab_hostname,
        "username" => "x-access-token",
        "password" => token
      }
    end
  end
end
