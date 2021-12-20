# frozen_string_literal: true

module Dependabot
  class FileFetcher < ApplicationService
    # Get specific file fetcher
    # @param [String] project_name
    # @param [Hash] config
    # @param [String] repo_contents_path
    def initialize(project_name, config, repo_contents_path)
      @project_name = project_name
      @config = config
      @repo_contents_path = repo_contents_path
    end

    attr_reader :project_name, :config, :repo_contents_path

    # Get FileFetcher
    #
    # @return [Dependabot::FileFetcher]
    def call
      Dependabot::FileFetchers.for_package_manager(config[:package_manager]).new(
        credentials: [*Credentials.call, *config[:registries]],
        repo_contents_path: repo_contents_path,
        source: Dependabot::DependabotSource.call(
          repo: project_name,
          branch: config[:branch],
          directory: config[:directory]
        )
      )
    end
  end
end
