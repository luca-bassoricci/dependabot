# frozen_string_literal: true

module Dependabot
  module Files
    class Parser < ApplicationService
      # @param [Array<Dependabot::DependencyFile>] dependency_files
      # @param [Dependabot::Source] source
      # @param [String] repo_contents_path
      # @param [Hash] config_entry
      # @param [Array<Hash>] credentials
      def initialize(dependency_files:, source:, repo_contents_path:, config_entry:, credentials:)
        @dependency_files = dependency_files
        @source = source
        @repo_contents_path = repo_contents_path
        @config_entry = config_entry
        @credentials = credentials
      end

      # Get parsed dependencies from files
      #
      # @return [Array<Dependabot::Dependency>]
      def call
        Dependabot::FileParsers.for_package_manager(config_entry[:package_manager]).new(
          dependency_files: dependency_files,
          source: source,
          credentials: credentials,
          repo_contents_path: repo_contents_path,
          reject_external_code: config_entry[:reject_external_code],
          options: config_entry[:updater_options]
        ).parse
      end

      private

      attr_reader :dependency_files,
                  :source,
                  :repo_contents_path,
                  :config_entry,
                  :credentials
    end
  end
end
