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
      # @return [void]
      def call
        log(:info, "Running update for merge request !#{mr_iid}")
        return log(:info, " merge request not in opened state, skipping") unless gitlab_mr.state == "opened"
        return rebase_mr unless recreate || gitlab_mr["has_conflicts"]

        Semaphore.synchronize { update }
      ensure
        FileUtils.rm_r(repo_contents_path, force: true, secure: true) if repo_contents_path
      end

      private

      delegate :configuration, to: :project, prefix: :project

      attr_reader :project_name, :mr_iid, :recreate

      # Rebase merge request
      #
      # @return [void]
      def rebase_mr
        gitlab.rebase_merge_request(project_name, mr_iid)
        log(:info, "  rebased merge request #{gitlab_mr.web_url}")
      end

      # Recreate merge request
      #
      # @return [void]
      def update
        return close_mr if updated_dependency.up_to_date?

        raise("Dependency update is impossible!") if updated_dependency.update_impossible?
        raise("Newer version for update exists, new merge request will be created!") unless same_version?

        Dependabot::PullRequestUpdater.new(
          credentials: Dependabot::Credentials.call,
          source: fetcher.source,
          base_commit: fetcher.commit,
          old_commit: mr.commit_message,
          pull_request_number: mr.iid,
          files: updated_dependency.updated_files,
          provider_metadata: { target_project_id: mr.target_project_id }
        ).update
        log(:info, "  recreated merge request #{gitlab_mr.web_url}")
      end

      # Updated dependency
      #
      # @return [Dependabot::Dependencies::UpdatedDependency]
      def updated_dependency
        dependency = Dependabot::Files::Parser.call(
          source: fetcher.source,
          dependency_files: fetcher.files,
          repo_contents_path: repo_contents_path,
          config_entry: config_entry,
          registries: registries
        ).find { |dep| dep.name == mr.main_dependency }
        return unless dependency

        Dependabot::Dependencies::UpdateChecker.call(
          dependency: dependency,
          dependency_files: fetcher.files,
          config_entry: config_entry,
          repo_contents_path: repo_contents_path,
          registries: registries
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
        @fetcher ||= Dependabot::Files::Fetcher.call(
          project_name: project_name,
          config_entry: config_entry,
          repo_contents_path: repo_contents_path,
          registries: registries
        )
      end

      # Get cloned repository path
      #
      # @return [String]
      def repo_contents_path
        return @repo_contents_path if defined?(@repo_contents_path)

        @repo_contents_path = DependabotCoreHelper.repo_contents_path(project_name, config_entry)
      end

      # Fetch config entry for update
      #
      # @return [Hash]
      def config_entry
        @config_entry ||= project_configuration.entry(package_ecosystem: mr.package_ecosystem, directory: mr.directory)
      end

      # Private registries configuration
      #
      # @return [Array<Hash>]
      def registries
        @registries ||= project_configuration.allowed_registries(
          package_ecosystem: mr.package_ecosystem,
          directory: mr.directory
        )
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
        # TODO: backwards compatibility for mrs create without update_to field, remove in minor next release
        return true unless mr.update_to

        mr.update_to == updated_dependency.current_versions
      end

      # Close obsolete merge request
      #
      # @return [void]
      def close_mr
        log(:info, "  dependency is already up to date, closing mr!")
        mr.close
        Gitlab::BranchRemover.call(project_name, mr.branch)
      end
    end
  end
end
