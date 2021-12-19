# frozen_string_literal: true

module Dependabot
  class MissingConfigurationError < StandardError; end

  class ConfigFetcher < ApplicationService
    # @param [String] project_name
    # @param [Boolean] update_cache
    # @param [Hash] find_by
    def initialize(project_name, branch: DependabotConfig.config_branch, update_cache: false, find_by: nil)
      @project_name = project_name
      @branch = branch
      @update_cache = update_cache
      @find_by = find_by
    end

    # Dependabot config hash
    #
    # @return [Hash<Symbol, Object>]
    def call
      cache_key = "#{project_name}-#{default_branch}-configuration"
      raw_config = Rails.cache.fetch(cache_key, expires_in: 12.hours, force: update_cache) do
        Gitlab::Config::Fetcher.call(project_name, default_branch).tap do |raw|
          next if raw

          raise(
            MissingConfigurationError,
            "#{DependabotConfig.config_filename} not present in #{project_name}'s branch #{branch}"
          )
        end
      end

      config = ConfigParser.call(raw_config, project_name)
      find_by ? config_entry(config) : config
    end

    private

    attr_reader :project_name, :branch, :update_cache, :find_by

    # Default branch
    #
    # @return [String]
    def default_branch
      @default_branch ||= branch || gitlab.project(project_name).default_branch
    end

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
