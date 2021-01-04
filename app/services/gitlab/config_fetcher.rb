# frozen_string_literal: true

module Gitlab
  class MissingConfigurationError < StandardError; end

  class ConfigFetcher < ApplicationService
    # @param [String] project_name
    def initialize(project_name, default_branch)
      @project_name = project_name
      @default_branch = default_branch
    end

    # Get dependabot.yml file contents
    #
    # @return [String]
    def call
      log(:info, "Fetching configuration for #{project_name} from #{default_branch}")
      gitlab.file_contents(project_name, AppConfig.config_filename, default_branch)
    rescue Error::NotFound
      raise(
        MissingConfigurationError,
        "#{AppConfig.config_filename} not present in #{project_name}'s branch #{default_branch}"
      )
    end

    private

    attr_reader :project_name, :default_branch
  end
end
