# frozen_string_literal: true

module Dependabot
  module Config
    # :reek:ControlParameter

    # Registries configuration parser
    #
    class RegistriesParser < ApplicationService
      SECRET_PATTERN = /\${{(\S+)}}/.freeze
      TYPE_MAPPING = {
        "maven-repository" => { type: "maven_repository", url: "url" },
        "docker-registry" => { type: "docker_registry", url: "registry" },
        "npm-registry" => { type: "npm_registry", url: "registry" },
        "composer-repository" => { type: "composer_repository", url: "registry" },
        "git" => { type: "git_source", url: "host" },
        "nuget-feed" => { type: "nuget_feed", url: "url" },
        "python-index" => { type: "python_index", url: "index-url" },
        "rubygems-server" => { type: "rubygems_server", url: "host" },
        "terraform-registry" => { type: "terraform_registry", url: "host" },
        "hex-organization" => { type: "hex_organization" }
      }.freeze

      def initialize(registries:)
        @registries = registries
      end

      # Fetch configured registries
      #
      # @return [Array<Hash>]
      def call
        return unless registries

        registries
          .map { |registry| transform_registry_values(registry) }
          .compact
      end

      private

      # @return [Array]
      attr_reader :registries

      # Schema for private regstry with no credentials
      #
      # @return [Dry::Schema::Params]
      def no_auth_private
        @no_auth_private ||= Dry::Schema.Params do
          config.validate_keys = true

          required(:type).filled(:string)
          required(:url).filled(:string)
        end
      end

      # Schema for private registry with username/password
      #
      # @return [Dry::Schema::Params]
      def auth_private_password
        @auth_private_password ||= Dry::Schema.Params do
          config.validate_keys = true

          required(:type).filled(:string)
          required(:url).filled(:string)
          required(:username).filled(:string)
          required(:password).filled(:string)
        end
      end

      # Schema for private registry with token authentication
      #
      # @return [Dry::Schema::Params]
      def auth_private_token
        @auth_private_token ||= Dry::Schema.Params do
          config.validate_keys = true

          required(:type).filled(:string)
          required(:url).filled(:string)
          required(:token).filled(:string)
        end
      end

      # Schema for private hex registry
      #
      # @return [void]
      def auth_hex
        @auth_hex ||= Dry::Schema.Params do
          config.validate_keys = true

          required(:type).filled(:string)
          required(:organization).filled(:string)
          required(:key).filled(:string)
        end
      end

      # Update registry hash
      #
      # dependabot-core uses specific credentials hash depending on registry types with keys as strings
      #
      # @param [Hash] registry
      # @return [Hash]
      def transform_registry_values(registry) # rubocop:disable Metrics/MethodLength
        type = registry[:type]
        mapped_type = TYPE_MAPPING[type]
        return warn_unsupported_registry(type) unless mapped_type
        return warn_incorrect_registry(type) unless registry_config_valid?(registry)

        if type == "hex-organizaton"
          return {
            "type" => mapped_type[:type],
            "organization" => registry[:organization],
            "token" => registry[:key]
          }
        end

        {
          "type" => mapped_type[:type],
          mapped_type[:url] => strip_protocol(type, env_value(registry[:url])),
          **registry.except(:type, :url).map { |key, value| [key.to_s, env_value(value)] }.to_h
        }
      end

      # Log warning for partially configured credentials
      #
      # @param [String] type
      # @return [nil]
      def warn_incorrect_registry(type)
        log(:error, "Got partially or incorrectly configured registry '#{type}'")
        nil
      end

      # Log warning for unsupported registry type
      #
      # @param [String] type
      # @return [nil]
      def warn_unsupported_registry(type)
        log(:error, "Registry type '#{type}' is not supported!")
        nil
      end

      # Check if registry credentials block is valid
      #
      # @param [Hash] registry
      # @return [Boolean]
      def registry_config_valid?(registry)
        no_auth_private.call(registry).success? ||
          auth_private_token.call(registry).success? ||
          auth_private_password.call(registry).success? ||
          auth_hex.call(registry).success?
      end

      # Fetch value from environment
      #
      # @param [String] value
      # @return [String]
      def env_value(value)
        return value unless value&.match?(SECRET_PATTERN)

        ENV[value.match(SECRET_PATTERN)[1]] || ""
      end

      # Strip protocol from registries of specific type
      #
      # Private npm and docker registries will not work if protocol is defined
      #
      # @param [String] type
      # @param [String] url
      # @return [String]
      def strip_protocol(type, url)
        return url unless %w[npm-registry docker-registry terraform-registry].include?(type)

        url.gsub(%r{https?://}, "")
      end
    end
  end
end
