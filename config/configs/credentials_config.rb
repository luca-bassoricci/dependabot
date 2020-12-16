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
    @maven_repos ||= credentials["maven"]&.map do |_, repository|
      if [repository["url"], repository["username"], repository["password"]].any?(&:nil?)
        log(:warn, "Got partially configured maven_repository credentials")
        next
      end

      { url: repository["url"], username: repository["username"], password: repository["password"] }
    end
  end

  # Array of private docker registries
  #
  # @return [Array]
  def docker_registries
    @docker_registries ||= credentials["docker"]&.map do |_, registry|
      if [registry["registry"], registry["username"], registry["password"]].any?(&:nil?)
        log(:warn, "Got partially configured docker_registry credentials")
        next
      end

      { registry: registry["registry"], username: registry["username"], password: registry["password"] }
    end
  end

  # Array of private npm registries
  #
  # @return [Array]
  def npm_registries
    @npm_registries ||= credentials["npm"]&.map do |_, registry|
      if [registry["registry"], registry["token"]].any?(&:nil?)
        log(:warn, "Got partially configured npm_registry credentials")
        next
      end

      { registry: registry["registry"], token: registry["token"] }
    end
  end
end
