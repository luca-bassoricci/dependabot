# frozen_string_literal: true

module Dependabot
  # :reek:InstanceVariableAssumption
  class MergeRequestRecreator < ApplicationService
    def initialize(project_name, mr_iid)
      @project_name = project_name
      @mr_iid = mr_iid
    end

    # Trigger merge request recreation
    #
    # @return [Gitlab::ObjectifiedHash]
    def call
      Dependabot::MergeRequestService.call(
        fetcher: fetcher,
        project: project,
        config: config,
        updated_dependency: updated_dependency,
        recreate: true
      )
    end

    private

    attr_reader :project_name, :mr_iid

    # Get cloned repository path
    #
    # @return [String]
    def repo_contents_path
      return @repo_contents_path if defined?(@repo_contents_path)

      @repo_contents_path = DependabotHelper.repo_contents_path(project_name, config)
    end

    # Find project
    #
    # @return [Project]
    def project
      @project ||= Project.find_by(name: project_name)
    end

    # Find merge request
    #
    # @return [MergeRequest]
    def mr
      @mr ||= project.merge_requests.find_by(iid: mr_iid)
    end

    # Fetch config for project
    #
    # @return [Hash]
    def config
      @config ||= Dependabot::Config.call(
        project_name,
        find_by: {
          package_manager: mr.package_manager,
          directory: mr.directory
        }
      )
    end

    # Get file fetcher
    #
    # @return [Dependabot::FileFetcher]
    def fetcher
      @fetcher ||= Dependabot::FileFetcher.call(project_name, config, repo_contents_path)
    end

    # Updated dependency
    #
    # @return [Dependabot::UpdatedDependency]
    def updated_dependency
      @updated_dependency ||= Dependabot::DependencyUpdater.call(
        project_name: project_name,
        config: config,
        fetcher: fetcher,
        name: mr.main_dependency,
        repo_contents_path: repo_contents_path
      )
    end
  end
end
