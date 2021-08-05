# frozen_string_literal: true

module Dependabot
  class MissingConfigurationError < StandardError; end

  class ConfigFetcher < ApplicationService
    # @param [String] project_name
    # @param [Boolean] update_cache
    # @param [Hash] find_by
    def initialize(project_name, update_cache: false, find_by: nil)
      @project_name = project_name
      @update_cache = update_cache
      @find_by = find_by
    end

    # Dependabot config hash
    #
    # @return [Hash<Symbol, Object>]
    def call
      raw_config = Rails.cache.fetch("#{project_name}-configuration", expires_in: 24.hours, force: update_cache) do
        branch = AppConfig.config_branch || gitlab.project(project_name).default_branch
        Gitlab::Config::Fetcher.call(project_name, branch, update_cache: update_cache).tap do |raw|
          next if raw

          raise(
            MissingConfigurationError,
            "#{AppConfig.config_filename} not present in #{project_name}'s branch #{branch}"
          )
        end
      end

      config = ConfigParser.call(raw_config)
      find_by ? config_entry(config) : config
    end

    private

    attr_reader :project_name, :update_cache, :find_by

    # Find single config entry
    #
    # @param [Array<Hash>] config
    # @return [Hash]
    def config_entry(config)
      config.detect do |conf|
        find_by.all? { |key, val| conf[key] == val }
      end
    end
  end
end
