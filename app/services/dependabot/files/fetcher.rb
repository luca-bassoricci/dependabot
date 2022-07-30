# frozen_string_literal: true

module Dependabot
  module Files
    class Fetcher < ApplicationService
      # Get specific file fetcher
      # @param [String] project_name
      # @param [Hash] config_entry
      # @param [Array<Hash>] registries
      # @param [String] repo_contents_path
      def initialize(project_name:, config_entry:, credentials:, repo_contents_path:)
        @project_name = project_name
        @config_entry = config_entry
        @credentials = credentials
        @repo_contents_path = repo_contents_path
      end

      attr_reader :project_name,
                  :config_entry,
                  :credentials,
                  :repo_contents_path

      # Get FileFetcher
      #
      # @return [Dependabot::FileFetcher]
      def call
        Dependabot::FileFetchers.for_package_manager(config_entry[:package_manager]).new(
          credentials: credentials,
          repo_contents_path: repo_contents_path,
          source: Dependabot::DependabotSource.call(
            repo: project_name,
            branch: config_entry[:branch],
            directory: config_entry[:directory]
          )
        )
      end
    end
  end
end
