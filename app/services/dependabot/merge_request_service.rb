# frozen_string_literal: true

module Dependabot
  class MergeRequestService < ApplicationService
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
      mr ? update_mr : create_mr
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
      )
      mr ? log(:info, "  created merge request: #{mr.web_url}") : log(:error, " failed to create merge request")
      return if AppConfig.standalone? || !mr

      save_mr
      close_superseeded_mrs
    end

    # Persist merge request
    #
    # @return [void]
    def save_mr
      MergeRequest.create!(
        project: project,
        iid: mr.iid,
        package_manager: config[:package_manager],
        directory: config[:directory],
        state: "opened",
        auto_merge: config[:auto_merge],
        dependencies: current_dependencies_name,
        main_dependency: name
      )
    end

    # Close superseeded merge requests
    #
    # @return [void]
    def close_superseeded_mrs
      superseeded_mrs.each do |existing_mr|
        Gitlab::MergeRequest::Closer.call(project.name, existing_mr.iid)
        Gitlab::MergeRequest::Commenter.call(
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
      return log(:info, " merge request #{mr.references.short} doesn't require updating") unless update_mr?

      log(:info, "  updating merge request #{mr.references.short}")
      Gitlab::MergeRequest::Updater.call(
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

      log(:info, "  accepting merge request #{mr.references.short}")
      Gitlab::MergeRequest::Acceptor.call(mr)
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
      @mr ||= Gitlab::MergeRequest::Finder.call(
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

    # Check if mr should be updated
    #
    # @return [Boolean]
    def update_mr?
      recreate || (rebase? || !mr["has_conflicts"])
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
  end
end
