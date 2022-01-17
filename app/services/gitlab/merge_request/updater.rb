# frozen_string_literal: true

module Gitlab
  module MergeRequest
    class Updater < ApplicationService
      # @param [Dependabot::Files::Fetchers::Base] fetcher
      # @param [Array<Dependabot::DependencyFile>] updated_files
      # @param [Gitlab::ObjectifiedHash] merge_request
      # @param [Number] target_project_id
      # @param [Boolean] recreate
      def initialize(fetcher:, updated_files:, merge_request:, target_project_id:, recreate: false)
        @fetcher = fetcher
        @updated_files = updated_files
        @mr = merge_request
        @target_project_id = target_project_id
        @recreate = recreate
      end

      # Rebase or recreate merge request
      #
      # @return [void]
      def call
        return rebase_mr unless recreate || mr.has_conflicts

        Dependabot::PullRequestUpdater.new(
          source: fetcher.source,
          base_commit: fetcher.commit,
          old_commit: mr.sha,
          files: updated_files,
          credentials: Dependabot::Credentials.call,
          pull_request_number: mr.iid,
          provider_metadata: { target_project_id: target_project_id }
        ).update
        log(:info, "  recreated merge request #{mr.web_url}")
      end

      private

      attr_reader :fetcher, :updated_files, :mr, :target_project_id, :recreate

      # Rebase merge request
      #
      # @return [void]
      def rebase_mr
        gitlab.rebase_merge_request(mr.project_id, mr.iid)
        log(:info, "  rebased merge request #{mr.web_url}")
      end
    end
  end
end
