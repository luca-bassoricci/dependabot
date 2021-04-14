# frozen_string_literal: true

# Credentials configuration
#
class CredentialsConfig < ApplicationConfig
  env_prefix :settings_

  attr_config :gitlab_access_token,
              :github_access_token,
              :gitlab_auth_token,
              # Private registries credentials
              # - maven
              # - docker
              # - npm
              credentials: {}

  required :gitlab_access_token

  # Array of private maven repository credentials
  #
  # @return [Array]
  def maven_repos
    @maven_repos ||= credentials["maven"]
      &.map { |_, repository| maven_creds(repository) }
      &.compact
  end

  # Array of private docker registries
  #
  # @return [Array]
  def docker_registries
    @docker_registries ||= credentials["docker"]
      &.map { |_, registry| docker_creds(registry) }
      &.compact
  end

  # Array of private npm registries
  #
  # @return [Array]
  def npm_registries
    @npm_registries ||= credentials["npm"]
      &.map { |_, registry| npm_creds(registry) }
      &.compact
  end

  private

  # Get maven credentials
  #
  # @param [Hash] repository
  # @return [<Hash, nil>]
  def maven_creds(repository)
    return repository if [repository["username"], repository["password"]].all?(&:nil?) && repository["url"]
    return repository if [repository["username"], repository["password"], repository["url"]].none?(&:nil?)

    warn_partial_credentials("maven_repository")
  end

  # Get docker credentials
  #
  # @param [Hash] registry
  # @return [<Hash, nil>]
  def docker_creds(registry)
    return registry if [registry["registry"], registry["username"], registry["password"]].none?(&:nil?)

    warn_partial_credentials("docker_registry")
  end

  # Get npm credentials
  #
  # @param [Hash] registry
  # @return [<Hash, nil>]
  def npm_creds(registry)
    return registry if [registry["registry"], registry["token"]].none?(&:nil?)

    warn_partial_credentials("npm_registry")
  end

  # Log warning for partially configured credentials
  #
  # @param [String] type
  # @return [nil]
  def warn_partial_credentials(type)
    log(:warn, "Got partially configured #{type} credentials")
    nil
  end
end
