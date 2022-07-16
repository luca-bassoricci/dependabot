# frozen_string_literal: true

module Dependabot
  module Config
    # :reek:ControlParameter

    # Registries configuration parser
    #
    class RegistriesParser < ApplicationService
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
      # @return [Hash]
      def call
        return {} unless registries

        registries
          .stringify_keys
          .transform_values { |registry| transform_registry_values(registry) }
          .compact
      end

      private

      # @return [Array]
      attr_reader :registries

      # Update registry hash
      #
      # dependabot-core uses specific credentials hash depending on registry types with keys as strings
      #
      # @param [Hash] registry
      # @return [Hash]
      def transform_registry_values(registry) # rubocop:disable Metrics/CyclomaticComplexity
        type = registry[:type]
        mapped_type = TYPE_MAPPING[type]
        return warn_unsupported_registry(type) unless mapped_type
        return warn_incorrect_registry(type) unless registry_config_valid?(registry)

        return hex(mapped_type, registry) if type == "hex-organizaton"
        return python(mapped_type, registry) if type == "python-index" && registry[:username] && registry[:password]

        {
          "type" => mapped_type[:type],
          mapped_type[:url] => strip_protocol(type, registry[:url]),
          **registry.except(:type, :url).transform_keys(&:to_s)
        }
      end

      # Hex organization
      #
      # @param [Hash] mapped_type
      # @param [Hash] registry
      # @return [Hash]
      def hex(mapped_type, registry)
        {
          "type" => mapped_type[:type],
          "organization" => registry[:organization],
          "token" => registry[:key]
        }
      end

      # Python index
      #
      # @param [Hash] mapped_type
      # @param [Hash] registry
      # @return [Hash]
      def python(mapped_type, registry)
        {
          "type" => mapped_type[:type],
          "token" => "#{registry[:username]}:#{registry[:password]}",
          "replaces-base" => registry[:"replaces-base"] || false,
          mapped_type[:url] => registry[:url]
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
        PrivateRegistries::NoAuthContract.new.call(registry).success? ||
          PrivateRegistries::TokenContract.new.call(registry).success? ||
          PrivateRegistries::PasswordContract.new.call(registry).success? ||
          PrivateRegistries::KeyContract.new.call(registry).success?
      end

      # Fetch value from environment
      #
      # @param [String, Boolean] value
      # @return [String, Boolean]
      def env_value(value)
        return value unless value.is_a?(String) && value.match?(SECRET_PATTERN)

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
