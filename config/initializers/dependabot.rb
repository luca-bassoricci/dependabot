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
      private

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

      def approvers_hash
        @approvers_hash ||= approvers.keys.map { |key| [key.to_sym, approvers[key]] }.to_h
      end
    end
  end

  class PullRequestUpdater
    class Gitlab
      # Hacky method override to be able to pass old commit message directly to pr updater
      #
      # @return [String]
      def commit_being_updated
        Struct.new(:title).new(old_commit)
      end
    end
  end

  # Log dependabot helpers output to debug level
  #
  module SharedHelpers
    # rubocop:disable Metrics/ParameterLists
    def self.run_helper_subprocess(
      command:,
      function:,
      args:,
      env: nil,
      stderr_to_stdout: false,
      allow_unsafe_shell_command: false
    )
      start = Time.zone.now
      stdin_data = JSON.dump(function: function, args: args)
      cmd = allow_unsafe_shell_command ? command : escape_command(command)

      env_cmd = [env, cmd].compact
      stdout, stderr, process = Open3.capture3(*env_cmd, stdin_data: stdin_data)
      time_taken = Time.zone.now - start

      # Some package managers output useful stuff to stderr instead of stdout so
      # we want to parse this, most package manager will output garbage here so
      # would mess up json response from stdout
      stdout = "#{stderr}\n#{stdout}" if stderr_to_stdout

      error_context = {
        command: command,
        function: function,
        args: args,
        time_taken: time_taken,
        stderr_output: stderr ? stderr[0..50_000] : "", # Truncate to ~100kb
        process_exit_value: process.to_s,
        process_termsig: process.termsig
      }

      response = JSON.parse(stdout)

      if process.success?
        log_helper_result(:debug, error_context, response)

        return response["result"]
      else
        log_helper_result(:error, error_context, response)
      end

      raise HelperSubprocessFailed.new(
        message: response["error"],
        error_class: response["error_class"],
        error_context: error_context,
        trace: response["trace"]
      )
    rescue JSON::ParserError
      raise HelperSubprocessFailed.new(
        message: stdout || "No output from command",
        error_class: "JSON::ParserError",
        error_context: error_context
      )
    end
    # rubocop:enable Metrics/ParameterLists

    # Log helper result
    #
    # @param [Hash] error_context
    # @param [Hash] response
    # @param [Hash] args
    # @return [void]
    def self.log_helper_result(level, error_context, response)
      debug_message = error_context.merge({ response: response, args: sanitize_args(error_context[:args]) })
      msg = (level == :error ? "core helpers failure: " : "core helpers output: ") + debug_message.to_json

      ApplicationHelper.log(level, msg)
    rescue StandardError => e
      ApplicationHelper.log(:debug, "failed to log core helper result: #{e}")
    end

    # Remove credentials from arguments
    #
    # @param [Object] args
    # @return [Object]
    def self.sanitize_args(args) # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
      if args.is_a?(Hash) && args[:credentials]
        args.merge({
          credentials: args[:credentials].map { |cred| cred.except(*::Config::AUTH_FIELDS) }
        })
      elsif args.is_a?(Array)
        args.map do |arg|
          next arg unless arg.is_a?(Array) && arg.any? do |item|
            item.is_a?(Hash) && ::Config::AUTH_FIELDS.any? { |key| item.key?(key) }
          end

          arg.map { |cred| cred.except(*::Config::AUTH_FIELDS) }
        end
      else
        args
      end
    end
  end
end
