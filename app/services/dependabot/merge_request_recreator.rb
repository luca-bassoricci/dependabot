# frozen_string_literal: true

module Dependabot
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
      @config ||= begin
        Dependabot::Config.call(
          project_name,
          find_by: {
            package_manager: mr.package_manager,
            directory: mr.directory
          }
        )
      end
    end

    # Get file fetcher
    #
    # @return [Dependabot::FileFetcher]
    def fetcher
      @fetcher ||= Dependabot::FileFetcher.call(project_name, config)
    end

    # Updated dependency
    #
    # @return [Dependabot::UpdatedDependency]
    def updated_dependency
      @updated_dependency ||= Dependabot::DependencyUpdater.call(
        project_name: project_name,
        config: config,
        fetcher: fetcher,
        name: mr.main_dependency
      )
    end
  end
end
