# frozen_string_literal: true

# Explicitly require as it's not found otherwise
require "dependabot/pull_request_updater"

module Gitlab
  module MergeRequest
    class Updater < ApplicationService
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
        log(:info, "rebasing merge request #{mr.references.short}")
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
end
