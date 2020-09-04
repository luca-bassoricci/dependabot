# frozen_string_literal: true

class Credentials
  class << self
    # Get credentials
    #
    # @return [Array<Hash>]
    def fetch
      @credentials ||= [github_credentials, gitlab_credentials, maven_repository_credentials].compact # rubocop:disable Naming/MemoizedInstanceVariableName
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

    # Get maven repository credentials
    #
    # @return [Hash]
    def maven_repository_credentials
      url = Settings.credentials_maven_repository_url
      username = Settings.credentials_maven_repository_username
      password = Settings.credentials_maven_repository_password

      return if [url, username, password].compact.empty?

      if [url, username, password].any?(&:nil?)
        Rails.logger.warn { "Got partially configured maven_repository credentials" }
        return
      end

      {
        "type" => "maven_repository",
        "url" => url,
        "username" => username,
        "password" => password
      }
    end
  end
end
