# frozen_string_literal: true

class Credentials
  delegate :logger, to: :Rails

  # Fetch credentials object
  #
  # @return [Array<Hash>]
  def self.fetch
    @credentials ||= new.credentials # rubocop:disable Naming/MemoizedInstanceVariableName
  end

  # Get credentials
  #
  # @return [Array<Hash>]
  def credentials
    [
      github_credentials,
      gitlab_credentials,
      maven_credentials
    ].compact
  end

  private

  # Get github credentials
  #
  # @return [Hash]
  def github_credentials
    token = Settings.github_access_token
    unless token
      logger.warn { "Missing github_access_token. Dependency updates may fail if api rate limit is exceeded." }
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
  def maven_credentials
    url = Settings.credentials_maven_repository_url
    username = Settings.credentials_maven_repository_username
    password = Settings.credentials_maven_repository_password

    return if [url, username, password].compact.empty?

    if [url, username, password].any?(&:nil?)
      logger.warn { "Got partially configured maven_repository credentials" }
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
