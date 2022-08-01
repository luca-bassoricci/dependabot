# frozen_string_literal: true

module Dependabot
  # Gitlab and Github credentials
  #
  class Credentials < ApplicationService
    def initialize(gitlab_access_token)
      @gitlab_access_token = gitlab_access_token
    end

    # Get credentials
    #
    # @return [Array<Hash>]
    def call
      [
        github_credentials,
        gitlab_credentials
      ].compact
    end

    private

    attr_reader :gitlab_access_token

    # Get github credentials
    #
    # @return [Hash]
    def github_credentials
      token = CredentialsConfig.github_access_token
      if token.blank?
        log(:warn, "Missing github_access_token. Dependency updates may fail if api rate limit is exceeded.")
        return
      end

      {
        "type" => "git_source",
        "host" => "github.com",
        "username" => "x-access-token",
        "password" => token
      }
    end

    # Get gitlab credentials
    #
    # @return [Hash]
    def gitlab_credentials
      {
        "type" => "git_source",
        "host" => URI(AppConfig.gitlab_url).host,
        "username" => "x-access-token",
        "password" => gitlab_access_token || CredentialsConfig.gitlab_access_token
      }
    end
  end
end
