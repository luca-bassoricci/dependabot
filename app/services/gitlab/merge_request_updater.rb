# frozen_string_literal: true

module Gitlab
  class MergeRequestUpdater < ApplicationService
    # @param [Dependabot::FileFetchers::Base] fetcher
    # @param [Array<Dependabot::DependencyFile>] updated_files
    # @param [Gitlab::ObjectifiedHash] merge_request
    def initialize(fetcher:, updated_files:, merge_request:)
      @fetcher = fetcher
      @updated_files = updated_files
      @mr = merge_request
    end

    # Update merge request
    #
    # @return [void]
    def call
      return logger.info { "merge request #{mr.references.short} doesn't require rebasing" } unless mr.has_conflicts

      logger.info { "rebasing merge request #{mr.references.short}" }
      Dependabot::PullRequestUpdater.new(
        source: fetcher.source,
        base_commit: fetcher.commit,
        old_commit: mr.sha,
        files: updated_files,
        credentials: Credentials.fetch,
        pull_request_number: mr.iid
      ).update
    end

    private

    attr_reader :fetcher, :updated_files, :mr
  end
end
