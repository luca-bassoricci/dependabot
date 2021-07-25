# frozen_string_literal: true

module Gitlab
  module Config
    class Fetcher < ApplicationService
      # @param [String] project_name
      def initialize(project_name, branch, update_cache: false)
        @project_name = project_name
        @branch = branch
        @update_cache = update_cache
      end

      # Get dependabot.yml file contents
      #
      # @return [String]
      def call
        log(:info, "Fetching configuration for #{project_name} from #{branch}")
        Rails.cache.fetch("#{project_name}-#{branch}-configuration", expires_in: 24.hours, force: update_cache) do
          gitlab.file_contents(project_name, AppConfig.config_filename, branch)
        end
      rescue Error::NotFound
        nil
      end

      private

      attr_reader :project_name, :branch, :update_cache
    end
  end
end
