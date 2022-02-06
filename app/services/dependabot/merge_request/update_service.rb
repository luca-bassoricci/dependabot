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
        return log(:info, "Merge request !#{mr_iid} not in opened state, skipping!") unless gitlab_mr.state == "opened"

        args = Semaphore.synchronize do
          {
            fetcher: fetcher,
            updated_files: updated_dependency&.updated_files,
            merge_request: gitlab_mr.to_hash.merge(commit_message: mr.commit_message),
            target_project_id: mr.target_project_id,
            recreate: recreate
          }
        end
        raise("Dependency could not be updated or already up to date!") unless updated_dependency
        raise("Newer version for update exists, new merge request will be created!") unless same_version?

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
        dependency = Dependabot::Files::Parser.call(
          source: fetcher.source,
          dependency_files: fetcher.files,
          repo_contents_path: repo_contents_path,
          config: config
        ).find { |dep| dep.name == mr.main_dependency }
        return unless dependency

        Dependabot::UpdateChecker.call(
          dependency: dependency,
          dependency_files: fetcher.files,
          config: config,
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
        @config ||= project.config.entry(package_ecosystem: mr.package_ecosystem, directory: mr.directory)
      end

      # Find merge request
      #
      # @return [MergeRequest]
      def mr
        @mr ||= project.merge_requests.find_by(iid: mr_iid)
      end

      # Gitlab merge request
      #
      # @return [Gitlab::ObjectifiedHash]
      def gitlab_mr
        @gitlab_mr ||= gitlab.merge_request(project_name, mr_iid)
      end

      # Check if newer version exist
      #
      # @return [Boolean]
      def same_version?
        # TODO: backwards compatibility for mrs create without update_to field, remove in next release
        return true unless mr.update_to

        mr.update_to == updated_dependency.current_versions
      end
    end
  end
end
