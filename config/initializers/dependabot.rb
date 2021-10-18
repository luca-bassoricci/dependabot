# frozen_string_literal: true

require "dependabot/pull_request_updater"

Dependabot::Utils.register_always_clone("go_modules")

# Patch dependabot mention sanitizer so it removes direct mentions
# Core implementation does this for github only
#
module Dependabot
  class PullRequestCreator
    class MessageBuilder
      class MetadataPresenter
        def sanitize_links_and_mentions(text, unsafe: false)
          LinkAndMentionSanitizer
            .new(github_redirection_service: github_redirection_service)
            .sanitize_links_and_mentions(text: text, unsafe: unsafe)
        end
      end
    end
  end
end

# Patch MR creation and to support reviewers and new approval rules
#
module Dependabot
  class PullRequestCreator
    class Gitlab
      def create_merge_request
        gitlab_client_for_source.create_merge_request(
          source.repo,
          pr_name,
          source_branch: branch_name,
          target_branch: source.branch || default_branch,
          description: pr_description,
          remove_source_branch: true,
          assignee_ids: assignees,
          labels: labeler.labels_for_pr.join(","),
          milestone_id: milestone,
          target_project_id: target_project_id,
          reviewer_ids: approvers_hash[:reviewers]
        )
      end

      def annotate_merge_request(merge_request)
        add_approvers_to_merge_request(merge_request)
      end

      def add_approvers_to_merge_request(merge_request)
        return unless approvers_hash[:approvers] || approvers_hash[:group_approvers]

        gitlab_client_for_source.create_merge_request_level_rule(
          target_project_id || source.repo,
          merge_request.iid,
          name: "dependency-updates",
          approvals_required: 0,
          user_ids: approvers_hash[:approvers],
          group_ids: approvers_hash[:group_approvers]
        )
      end

      private

      def approvers_hash
        @approvers_hash ||= approvers.keys.map { |k| [k.to_sym, approvers[k]] }.to_h
      end
    end
  end
end
