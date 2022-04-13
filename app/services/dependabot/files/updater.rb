# frozen_string_literal: true

module Dependabot
  module Files
    class Updater < ApplicationService
      # @param [Array<Dependabot::Dependency>] dependencies
      # @param [Array<Dependabot::DependencyFile>] dependency_files
      # @param [String] repo_contents_path
      # @param [Array] credentials
      # @param [Hash] config_entry
      def initialize(dependencies:, dependency_files:, repo_contents_path:, credentials:, config_entry:)
        @dependencies = dependencies
        @dependency_files = dependency_files
        @repo_contents_path = repo_contents_path
        @credentials = credentials
        @config_entry = config_entry
      end

      # Get update checker
      #
      # @return [Array<Dependabot::DependencyFile>]
      def call
        Dependabot::FileUpdaters.for_package_manager(config_entry[:package_manager]).new(
          dependencies: dependencies,
          dependency_files: dependency_files,
          credentials: credentials,
          repo_contents_path: repo_contents_path,
          options: config_entry[:updater_options]
        ).updated_dependency_files
      end

      private

      attr_reader :dependencies,
                  :dependency_files,
                  :repo_contents_path,
                  :credentials,
                  :config_entry
    end
  end
end
