# frozen_string_literal: true

module Gitlab
  module MergeRequest
    class Updater < ApplicationService
      # @param [Dependabot::FileFetchers::Base] fetcher
      # @param [Array<Dependabot::DependencyFile>] updated_files
      # @param [Gitlab::ObjectifiedHash] merge_request
      # @param [Number] target_project_id
      def initialize(fetcher:, updated_files:, merge_request:, target_project_id:)
        @fetcher = fetcher
        @updated_files = updated_files
        @mr = merge_request
        @target_project_id = target_project_id
      end

      # Update merge request
      #
      # @return [void]
      def call
        Dependabot::PullRequestUpdater.new(
          source: fetcher.source,
          base_commit: fetcher.commit,
          old_commit: mr.sha,
          files: updated_files,
          credentials: Dependabot::Credentials.call,
          pull_request_number: mr.iid,
          target_project_id: target_project_id
        ).update
      end

      private

      attr_reader :fetcher, :updated_files, :mr, :target_project_id
    end
  end
end
