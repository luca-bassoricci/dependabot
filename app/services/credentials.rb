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
      maven_credentials,
      docker_credentials,
      npm_registry
    ].flatten.compact
  end

  private

  # Get github credentials
  #
  # @return [Hash]
  def github_credentials
    token = CredentialsConfig.github_access_token
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
      "host" => URI(AppConfig.gitlab_url).host,
      "username" => "x-access-token",
      "password" => CredentialsConfig.gitlab_access_token
    }
  end

  # Get maven repository credentials
  #
  # @return [Hash]
  def maven_credentials
    CredentialsConfig.maven_repos&.map do |repository|
      {
        "type" => "maven_repository",
        "url" => repository[:url],
        "username" => repository[:username],
        "password" => repository[:password]
      }
    end
  end

  # Get docker registry credentials
  #
  # @return [Hash]
  def docker_credentials
    CredentialsConfig.docker_registries&.map do |registry|
      {
        "type" => "docker_registry",
        "registry" => registry[:registry],
        "username" => registry[:username],
        "password" => registry[:password]
      }
    end
  end

  # Get npm registry credentials
  #
  # @return [Hash]
  def npm_registry
    CredentialsConfig.npm_registries&.map do |registry|
      {
        "type" => "npm_registry",
        "registry" => registry[:registry],
        "token" => registry[:token]
      }
    end
  end
end
