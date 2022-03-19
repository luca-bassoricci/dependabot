# frozen_string_literal: true

module Dependabot
  # Git and registries credentials
  #
  class Credentials < ApplicationService
    # Fetch credentials object
    #
    # @return [Array<Hash>]
    def self.call
      @credentials ||= new.credentials # rubocop:disable Naming/MemoizedInstanceVariableName
    end

    # Get credentials
    #
    # @return [Array<Hash>]
    def credentials
      [
        github_credentials,
        gitlab_credentials
      ].compact
    end

    private

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
        "password" => CredentialsConfig.gitlab_access_token
      }
    end
  end
end
