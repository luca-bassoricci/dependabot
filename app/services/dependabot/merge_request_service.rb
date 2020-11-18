# frozen_string_literal: true

module Dependabot
  class MergeRequestService < ApplicationService
    # @param [String] name Updated dependency name for logging
    # @param [Dependabot::FileFetchers::Base] fetcher
    # @param [Array<Dependabot::Dependency>] updated_dependencies
    # @param [Array<Dependabot::DependencyFile>] updated_files
    # @param [Hash] opts
    def initialize(fetcher:, updated_dependencies:, updated_files:, project:, **config)
      @fetcher = fetcher
      @updated_dependencies = updated_dependencies
      @updated_files = updated_files
      @project = project
      @config = config
    end

    # Create or update MR
    #
    # @return [void]
    def call
      logger.info { "Updating following dependencies: #{updated_dependencies_name}" }
      mr ? update_mr : create_mr
      accept_mr

      mr
    end

    private

    attr_reader :project, :fetcher, :updated_dependencies, :updated_files, :config

    # Create mr
    #
    # @return [void]
    def create_mr
      @mr = Gitlab::MergeRequestCreator.call(
        fetcher: fetcher,
        updated_dependencies: updated_dependencies,
        updated_files: updated_files,
        config: config
      )
      return if Settings.standalone

      save
      close_superseeded_mrs
    end

    # Persist merge request
    #
    # @return [void]
    def save
      return unless mr

      MergeRequest.create!(
        project: project,
        iid: mr.iid,
        package_manager: config[:package_manager],
        state: "opened",
        auto_merge: config[:auto_merge],
        dependencies: current_dependencies_name
      )
    end

    # Close superseeded merge requests
    #
    # @return [void]
    def close_superseeded_mrs
      superseeded_mrs.each do |existing_mr|
        Gitlab::MergeRequestCloser.call(project.name, existing_mr.iid)
        Gitlab::MergeRequestCommenter.call(
          project.name, existing_mr.iid,
          "This merge request has been superseeded by #{mr.web_url}"
        )
        existing_mr.update_attributes!(state: "closed")
      end
    end

    # Rebase existing mr if it has conflicts
    #
    # @return [void]
    def update_mr
      return unless rebase?

      Gitlab::MergeRequestUpdater.call(
        fetcher: fetcher,
        updated_files: updated_files,
        merge_request: mr
      )
    end

    # Accept merge request and set to merge automatically
    #
    # @return [void]
    def accept_mr
      return unless mr && config[:auto_merge]

      Gitlab::MergeRequestAcceptor.call(mr)
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
    # @return [Gitlab::ObjectifiedHash] if mr exists
    #
    # @return [nil] if merge request doesn't exist
    def mr
      @mr ||= Gitlab::MergeRequestFinder.call(
        project: fetcher.source.repo,
        source_branch: source_branch,
        target_branch: fetcher.source.branch,
        state: "opened"
      )
    end

    # Automatically rebase MR
    #
    # @return [Boolean]
    def rebase?
      config[:rebase_strategy] == "auto"
    end

    # All dependencies to be updated with latest versions
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
                                  .where(dependencies: current_dependencies_name)
                                  .not(iid: mr.iid).not(state: "closed")
    end
  end
end
