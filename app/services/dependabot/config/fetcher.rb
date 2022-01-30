# frozen_string_literal: true

module Dependabot
  module Config
    class MissingConfigurationError < StandardError; end

    class Fetcher < ApplicationService
      # @param [String] project_name
      # @param [String] branch
      # @param [Boolean] update_cache
      def initialize(project_name, branch: DependabotConfig.config_branch, update_cache: false)
        @project_name = project_name
        @branch = branch
        @update_cache = update_cache
      end

      # Dependabot config
      #
      # @return [Config]
      def call
        cache_key = "#{project_name}-#{default_branch}-configuration"
        raw_config = Rails.cache.fetch(cache_key, expires_in: 12.hours, force: update_cache) do
          raw = Gitlab::ConfigFile::Fetcher.call(project_name, default_branch)
          raw || raise(
            MissingConfigurationError,
            "#{DependabotConfig.config_filename} not present in #{project_name}'s branch #{branch}"
          )
        end

        ::Config.new(Parser.call(raw_config, project_name))
      end

      private

      attr_reader :project_name, :branch, :update_cache, :find_by

      # Default branch
      #
      # @return [String]
      def default_branch
        @default_branch ||= branch || gitlab.project(project_name).default_branch
      end
    end
  end
end
