# frozen_string_literal: true

module Gitlab
  module ConfigFile
    # Check if config file exists in repository
    #
    class Checker < ApplicationService
      def initialize(project_name, default_branch)
        @project_name = project_name
        @default_branch = default_branch
      end

      # Get config file from repo
      #
      # @return [boolean]
      def call
        gitlab.get_file(project_name, DependabotConfig.config_filename, default_branch) && true
      rescue Error::NotFound
        false
      end

      private

      attr_reader :project_name, :default_branch
    end
  end
end
