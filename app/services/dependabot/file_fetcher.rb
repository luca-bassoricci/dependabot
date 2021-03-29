# frozen_string_literal: true

module Dependabot
  class FileFetcher < ApplicationService
    # Get specific file fetcher
    # @param [Dependabot::Source] source
    # @param [String] package_manager
    def initialize(project_name, config)
      @project_name = project_name
      @config = config
    end

    attr_reader :project_name, :config

    # Get FileFetcher
    #
    # @return [Dependabot::FileFetcher]
    def call
      Dependabot::FileFetchers.for_package_manager(config[:package_manager]).new(
        credentials: Credentials.fetch,
        repo_contents_path: DependabotHelper.repo_contents_path(project_name, config),
        source: Dependabot::DependabotSource.call(
          repo: project_name,
          branch: config[:branch],
          directory: config[:directory]
        )
      )
    end
  end
end
