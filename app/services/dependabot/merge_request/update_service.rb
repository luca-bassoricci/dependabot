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
            merge_request: gitlab_mr,
            target_project_id: mr.target_project_id,
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

      # Find project
      #
      # @return [Project]
      def project
        @project ||= Project.find_by(name: project_name)
      end

      # Get file fetcher
      #
      # @return [Dependabot::Files::Fetcher]
      def fetcher
        @fetcher ||= Dependabot::Files::Fetcher.call(project_name, config, repo_contents_path)
      end

      # Get cloned repository path
      #
      # @return [String]
      def repo_contents_path
        return @repo_contents_path if defined?(@repo_contents_path)

        @repo_contents_path = DependabotCoreHelper.repo_contents_path(project_name, config)
      end

      # Fetch config entry for update
      #
      # @return [Hash]
      def config
        @config ||= project.config.find do |conf|
          conf[:package_ecosystem] == mr.package_ecosystem && conf[:directory] == mr.directory
        end
      end

      # Find merge request
      #
      # @return [MergeRequest]
      def mr
        @mr ||= project.merge_requests.find_by(iid: mr_iid)
      end

      # Gitlab merge request
      #
      # @return [Hash]
      def gitlab_mr
        @gitlab_mr ||= gitlab.merge_request(project_name, mr_iid)
                             .to_hash
                             .merge(commit_message: mr.commit_message)
      end
    end
  end
end
