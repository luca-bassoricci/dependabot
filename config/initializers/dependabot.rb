# frozen_string_literal: true

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

# rubocop:disable Metrics/MethodLength, Metrics/ParameterLists

# Patch MR creation to add ability creating MR's against forks
#
module Dependabot
  class PullRequestCreator
    attr_reader :target_project_id

    def initialize(
      source:,
      base_commit:,
      dependencies:,
      files:,
      credentials:,
      pr_message_header: nil,
      pr_message_footer: nil,
      custom_labels: nil,
      author_details: nil,
      signature_key: nil,
      commit_message_options: {},
      vulnerabilities_fixed: {},
      reviewers: nil,
      assignees: nil,
      milestone: nil,
      branch_name_separator: "/",
      branch_name_prefix: "dependabot",
      label_language: false,
      automerge_candidate: false,
      github_redirection_service: DEFAULT_GITHUB_REDIRECTION_SERVICE,
      custom_headers: nil,
      require_up_to_date_base: false,
      provider_metadata: {},
      message: nil,
      target_project_id: nil
    )
      @dependencies = dependencies
      @source                     = source
      @base_commit                = base_commit
      @files                      = files
      @credentials                = credentials
      @pr_message_header          = pr_message_header
      @pr_message_footer          = pr_message_footer
      @author_details             = author_details
      @signature_key              = signature_key
      @commit_message_options     = commit_message_options
      @custom_labels              = custom_labels
      @reviewers                  = reviewers
      @assignees                  = assignees
      @milestone                  = milestone
      @vulnerabilities_fixed      = vulnerabilities_fixed
      @branch_name_separator      = branch_name_separator
      @branch_name_prefix         = branch_name_prefix
      @label_language             = label_language
      @automerge_candidate        = automerge_candidate
      @github_redirection_service = github_redirection_service
      @custom_headers             = custom_headers
      @require_up_to_date_base    = require_up_to_date_base
      @provider_metadata          = provider_metadata
      @message                    = message
      @target_project_id          = target_project_id

      check_dependencies_have_previous_version
    end

    def gitlab_creator
      Gitlab.new(
        source: source,
        branch_name: branch_namer.new_branch_name,
        base_commit: base_commit,
        credentials: credentials,
        files: files,
        commit_message: message.commit_message,
        pr_description: message.pr_message,
        pr_name: message.pr_name,
        author_details: author_details,
        labeler: labeler,
        approvers: reviewers,
        assignees: assignees,
        milestone: milestone,
        target_project_id: target_project_id
      )
    end
  end
end

module Dependabot
  class PullRequestCreator
    class Gitlab
      attr_reader :target_project_id

      def initialize(
        source:,
        branch_name:,
        base_commit:,
        credentials:,
        files:,
        commit_message:,
        pr_description:,
        pr_name:,
        author_details:,
        labeler:,
        approvers:,
        assignees:,
        milestone:,
        target_project_id:
      )
        @source             = source
        @branch_name        = branch_name
        @base_commit        = base_commit
        @credentials        = credentials
        @files              = files
        @commit_message     = commit_message
        @pr_description     = pr_description
        @pr_name            = pr_name
        @author_details     = author_details
        @labeler            = labeler
        @approvers          = approvers
        @assignees          = assignees
        @milestone          = milestone
        @target_project_id  = target_project_id
      end
      # rubocop:enable Metrics/ParameterLists

      def merge_request_exists?
        gitlab_client_for_source.merge_requests(
          target_project_id || source.repo,
          source_branch: branch_name,
          target_branch: source.branch || default_branch,
          state: "all"
        ).any?
      end

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
          target_project_id: target_project_id
        )
      end

      def add_approvers_to_merge_request(merge_request)
        approvers_hash = approvers.keys.map { |k| [k.to_sym, approvers[k]] }.to_h

        gitlab_client_for_source.create_merge_request_level_rule(
          merge_request.project_id,
          merge_request.iid,
          name: "Dependency updates",
          approvals_required: 1,
          user_ids: approvers_hash[:approvers],
          group_ids: approvers_hash[:group_approvers]
        )
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
