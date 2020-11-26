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
      logger.info { "Fetching configuration for #{project_name} from #{default_branch}" }
      gitlab.file_contents(project_name, ".gitlab/dependabot.yml", default_branch)
    rescue Error::NotFound
      raise(MissingConfigurationError, ".gitlab/dependabot.yml not present in #{repo}'s branch #{default_branch}")
    end

    private

    attr_reader :project_name, :default_branch
  end
end
