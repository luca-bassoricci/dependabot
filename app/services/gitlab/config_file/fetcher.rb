# frozen_string_literal: true

module Gitlab
  module ConfigFile
    class Fetcher < ApplicationService
      using Rainbow

      # @param [String] project_name
      def initialize(project_name, branch)
        @project_name = project_name
        @branch = branch
      end

      # Get dependabot.yml file contents
      #
      # @return [String]
      def call
        log(:info, "Fetching configuration for #{project_name.bright} from #{branch.bright}")
        gitlab.file_contents(project_name, DependabotConfig.config_filename, branch)
      rescue Error::NotFound, Error::BadRequest => e
        log_error(e) if e.is_a?(Error::BadRequest)
        nil
      end

      private

      attr_reader :project_name, :branch
    end
  end
end
