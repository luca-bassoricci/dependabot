# frozen_string_literal: true

class Credentials
  class << self
    # Get credentials
    #
    # @return [Array<Hash>]
    def fetch
      @credentials ||= [github_credentials, gitlab_credentials].compact # rubocop:disable Naming/MemoizedInstanceVariableName
    end

    private

    # Get github credentials
    #
    # @return [Hash]
    def github_credentials
      token = Settings.github_access_token
      unless token
        Rails.logger.warn { "Missing github_access_token. Dependency updates may fail if api rate limit is exceeded." }
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
        "host" => URI(Settings.gitlab_url).host,
        "username" => "x-access-token",
        "password" => Settings.gitlab_access_token
      }
    end
  end
end
