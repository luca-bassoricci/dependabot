# frozen_string_literal: true

module Dependabot
  class MergeRequestService < ApplicationService # rubocop:disable Metrics/ClassLength
    # @param [Dependabot::FileFetchers::Base] fetcher
    # @param [Project] project
    # @param [Hash] config
    # @param [Dependabot::UpdatedDependency] updated_dependency
    # :reek:BooleanParameter
    def initialize(fetcher:, project:, config:, updated_dependency:, recreate: false)
      @fetcher = fetcher
      @project = project
      @config = config
      @updated_dependency = updated_dependency
      @recreate = recreate
    end

    # Create or update MR
    #
    # @return [void]
    def call
      log(:info, "Updating following dependencies: #{updated_dependencies_name}")
      return log(:warn, " closed mr exists, skipping!") if find_mr("closed")

      if create_mr
        persist_mr
        close_superseeded_mrs
      else
        update_mr
      end

      accept_mr
      mr
    end

    private

    delegate :updated_files, :updated_dependencies, :name, to: :updated_dependency

    attr_reader :project, :fetcher, :updated_dependency, :config, :recreate

    # Create mr
    #
    # @return [void]
    def create_mr
      @mr = Gitlab::MergeRequest::Creator.call(
        fetcher: fetcher,
        updated_dependencies: updated_dependencies,
        updated_files: updated_files,
        config: config
      ) || return # dependabot-core returns nil if branch && mr exists and nothing was created

      log(:info, "  created merge request: #{mr.web_url}")
      mr
    rescue Gitlab::Error::Conflict
      # dependabot-core will try to create mr in the edge case when mr exists without the branch
      nil
    rescue Gitlab::Error => e # rescue in case mr is created but failed to add approvers/reviewers
      raise unless mr

      log_error(e)
      capture_error(e)
      mr
    end

    # Persist merge request
    #
    # @return [void]
    def persist_mr
      return if AppConfig.standalone?

      MergeRequest.create!(
        project: project,
        iid: mr.iid,
        package_manager: config[:package_manager],
        directory: config[:directory],
        state: "opened",
        auto_merge: config[:auto_merge],
        dependencies: current_dependencies_name,
        main_dependency: name,
        branch: source_branch
      )
    end

    # Close superseeded merge requests
    #
    # @return [void]
    def close_superseeded_mrs
      return if AppConfig.standalone?

      superseeded_mrs.each do |existing_mr|
        name = project.name

        Gitlab::MergeRequest::Closer.call(name, existing_mr.iid)
        Gitlab::BranchRemover.call(project.name, existing_mr.branch)
        Gitlab::MergeRequest::Commenter.call(
          name,
          existing_mr.iid,
          "This merge request has been superseeded by #{mr.web_url}"
        )
        existing_mr.update_attributes!(state: "closed")
      end
    end

    # Rebase existing mr if it has conflicts
    #
    # @return [void]
    def update_mr
      return log(:info, " merge request #{mr.references.short} doesn't require updating") unless update_mr?

      Gitlab::MergeRequest::Updater.call(
        fetcher: fetcher,
        updated_files: updated_files,
        merge_request: mr
      )
      log(:info, "  updated merge request #{mr.references.short}")
    end

    # Accept merge request and set to merge automatically
    #
    # @return [void]
    def accept_mr
      return unless AppConfig.standalone
      return unless mr && config[:auto_merge]

      Gitlab::MergeRequest::Acceptor.call(project.name, mr.iid, merge_when_pipeline_succeeds: true)
      log(:info, "  accepted merge request #{mr.references.short}")
    rescue Gitlab::Error::MethodNotAllowed, Gitlab::Error::NotAcceptable => e
      log(:error, " failed to accept merge request: #{e.message}")
    end

    # Get source branch name
    #
    # @return [String]
    def source_branch
      @source_branch ||= Dependabot::PullRequestCreator::BranchNamer.new(
        dependencies: updated_dependencies,
        files: updated_files,
        target_branch: fetcher.source.branch,
        separator: config[:branch_name_separator],
        prefix: config[:branch_name_prefix]
      ).new_branch_name
    end

    # Get existing mr
    #
    # @return [Gitlab::ObjectifiedHash]
    def mr
      @mr ||= find_mr("opened")
    end

    # Automatically rebase MR
    #
    # @return [Boolean]
    def rebase?
      config[:rebase_strategy] == "auto"
    end

    # Check if mr should be updated
    #
    # @return [Boolean]
    def update_mr?
      recreate || (rebase? && mr["has_conflicts"])
    end

    # All dependencies to be updated with new versions
    #
    # @return [String]
    def updated_dependencies_name
      @updated_dependencies_name ||= updated_dependencies.map { |dep| "#{dep.name}-#{dep.version}" }.join("/")
    end

    # All dependencies being updated with current versions
    #
    # @return [String]
    def current_dependencies_name
      @current_dependencies_name ||= updated_dependencies.map { |dep| "#{dep.name}-#{dep.previous_version}" }.join("/")
    end

    # List of open superseeded merge requests
    #
    # @return [Mongoid::Criteria]
    def superseeded_mrs
      @superseeded_mrs ||= project.merge_requests
                                  .where(dependencies: current_dependencies_name, state: "opened")
                                  .not(iid: mr.iid)
                                  .compact
    end

    # Find existing mr
    #
    # @return [Gitlab::ObjectifiedHash]
    def find_mr(state)
      Gitlab::MergeRequest::Finder.call(
        project: fetcher.source.repo,
        source_branch: source_branch,
        target_branch: fetcher.source.branch,
        state: state
      )
    end
  end
end
