# frozen_string_literal: true

require "dependabot/pull_request_updater"

Dependabot::Utils.register_always_clone("go_modules")

# Dependabot patches
#
module Dependabot
  # Patch dependabot mention sanitizer so it removes direct mentions
  # Core implementation does this for github only
  #
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
    # rubocop:disable Metrics/ParameterLists, Metrics/MethodLength
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
      ApplicationHelper.log(:debug, "Performing native helper command: '#{cmd}'", tags: ["core"])
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
    # rubocop:enable Metrics/ParameterLists, Metrics/MethodLength

    # Log helper result
    #
    # @param [Hash] error_context
    # @param [Hash] response
    # @param [Hash] args
    # @return [void]
    def self.log_helper_result(level, error_context, response)
      ApplicationHelper.log(level, tags: ["core"]) do
        debug_message = error_context.merge({ response: response, args: sanitize_args(error_context[:args]) })

        "Helpers output:\n#{JSON.pretty_generate(debug_message)}"
      end
    rescue StandardError => e
      ApplicationHelper.log(:debug, "Failed to log helper result: #{e}", tags: ["core"])
    end

    # Remove credentials from arguments
    #
    # @param [Object] args
    # @return [Object]
    def self.sanitize_args(args) # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
      credentials_hash = args.is_a?(Hash) && args[:credentials]

      return args unless credentials_hash || args.is_a?(Array)
      return args.merge({ credentials: sanitize_auth_fields(args[:credentials]) }) if credentials_hash

      args.map do |arg|
        next arg unless arg.is_a?(Array) && arg.any? do |item|
          item.is_a?(Hash) && ::Registries::AUTH_FIELDS.any? { |key| item.key?(key) }
        end

        sanitize_auth_fields(arg)
      end
    end

    # Replace sensitive fields in credentials hash
    #
    # @param [Hash] credentials
    # @return [Hash]
    def self.sanitize_auth_fields(credentials)
      credentials.map do |cred|
        cred.each_with_object({}) do |(key, value), hsh|
          next hsh[key] = value unless ::Registries::AUTH_FIELDS.any? { |name| name == key }

          hsh[key] = "*****"
        end
      end
    end
  end

  module Clients
    # Add additional logging and retryable errors
    #
    class GitlabWithRetries
      delegate :log, to: :ApplicationHelper

      def retry_connection_failures
        retry_attempt = 0

        begin
          yield
        rescue Gitlab::Error::MethodNotAllowed, Gitlab::Error::NotAcceptable, *RETRYABLE_ERRORS => e
          retry_attempt += 1
          raise unless retry_attempt <= @max_retries

          log(:warn, "Gitlab request failed with: '#{e}'. Retrying...")
          retry
        end
      end
    end
  end
end
