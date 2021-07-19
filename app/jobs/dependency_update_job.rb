# frozen_string_literal: true

class DependencyUpdateJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 2

  # Perform dependency updates and merge request creation
  #
  # @param [Hash] args
  # @return [void]
  def perform(args)
    validate_args(args)
    save_job_context(args)
    UpdateFailures.call.reset_errors

    Dependabot::UpdateService.call(args)
  rescue StandardError => e
    capture_error(e)
    raise
  end

  # Validate arguments
  #
  # @param [Hash] args
  # @return [void]
  def validate_args(args)
    blank_keys = args.select { |_key, value| value.blank? }.keys

    raise(ArgumentError, "#{blank_keys} must not be blank") unless blank_keys.empty?
  end

  # Save context for tagged logger
  #
  # @param [Hash] args
  # @return [void]
  def save_job_context(args)
    context = args.values_at("project_name", "package_ecosystem", "directory")
    context.pop if context.last == "/"

    Thread.current[:context] = context.join("=>")
  end
end
