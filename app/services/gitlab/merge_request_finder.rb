# frozen_string_literal: true

module Gitlab
  class MergeRequestFinder < ApplicationService
    # @param [String] project
    # @param [String] source_branch>
    # @param [String] target_branch
    # @param [String] state
    def initialize(project:, source_branch:, target_branch:, state: "opened")
      @project = project
      @source_branch = source_branch
      @target_branch = target_branch
      @state = state
    end

    # Find merge request
    #
    # @return [Gitlab::ObjectifiedHash]
    def call
      gitlab.merge_requests(
        project,
        source_branch: source_branch,
        target_branch: target_branch,
        state: state,
        with_merge_status_recheck: true
      )&.first
    end

    private

    attr_reader :project, :source_branch, :target_branch, :state
  end
end
