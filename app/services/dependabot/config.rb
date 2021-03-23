# frozen_string_literal: true

module Dependabot
  class Config < ApplicationService
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
      default_branch = Gitlab::DefaultBranch.call(project_name)
      config = Rails.cache.fetch("#{project_name}-config", expires_in: 24.hours, force: update_cache) do
        Configuration::Parser.call(Gitlab::ConfigFetcher.call(project_name, default_branch))
      end

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
