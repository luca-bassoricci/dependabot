# frozen_string_literal: true

module Gitlab
  module Config
    class MissingConfigurationError < StandardError; end

    class Fetcher < ApplicationService
      # @param [String] project_name
      def initialize(project_name, branch)
        @project_name = project_name
        @branch = branch
      end

      # Get dependabot.yml file contents
      #
      # @return [String]
      def call
        log(:info, "Fetching configuration for #{project_name} from #{branch}")
        gitlab.file_contents(project_name, AppConfig.config_filename, branch)
      rescue Error::NotFound
        raise(
          MissingConfigurationError,
          "#{AppConfig.config_filename} not present in #{project_name}'s branch #{branch}"
        )
      end

      private

      attr_reader :project_name, :branch
    end
  end
end
