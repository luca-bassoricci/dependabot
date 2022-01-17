# frozen_string_literal: true

module Dependabot
  # :reek:InstanceVariableAssumption
  module MergeRequest
    class UpdateService < ApplicationService
      def initialize(project_name:, mr_iid:, recreate: true)
        @project_name = project_name
        @mr_iid = mr_iid
        @recreate = recreate
      end

      # Trigger merge request update
      #
      # @return [Gitlab::ObjectifiedHash]
      def call
        args = Semaphore.synchronize do
          {
            fetcher: fetcher,
            updated_files: updated_dependency&.updated_files,
            merge_request: mr,
            target_project_id: config[:fork] ? project.forked_from_id : nil,
            recreate: recreate
          }
        end
        return unless updated_dependency

        Gitlab::MergeRequest::Updater.call(**args)
      ensure
        FileUtils.rm_r(repo_contents_path, force: true, secure: true) if repo_contents_path
      end

      private

      attr_reader :project_name, :mr_iid, :recreate

      # Get cloned repository path
      #
      # @return [String]
      def repo_contents_path
        return @repo_contents_path if defined?(@repo_contents_path)

        @repo_contents_path = DependabotCoreHelper.repo_contents_path(project_name, config)
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
        @config ||= Dependabot::Config::Fetcher.call(
          project_name,
          find_by: {
            package_ecosystem: mr.package_ecosystem,
            directory: mr.directory
          }
        )
      end

      # Get file fetcher
      #
      # @return [Dependabot::Files::Fetcher]
      def fetcher
        @fetcher ||= Dependabot::Files::Fetcher.call(project_name, config, repo_contents_path)
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
end
