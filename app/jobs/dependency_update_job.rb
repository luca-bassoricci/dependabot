# frozen_string_literal: true

class DependencyUpdateJob < ApplicationJob
  queue_as :default

  sidekiq_options retry: AppConfig.sidekiq_retry

  # Perform dependency updates and merge request creation
  #
  # @param [Hash] args
  # @return [void]
  def perform(args)
    validate_args(args)
    set_execution_context(args)
    UpdateFailures.call.reset_errors

    Dependabot::UpdateService.call(args)
  rescue StandardError => e
    capture_error(e)
    raise
  ensure
    set_execution_context(nil)
  end

  # Validate arguments
  #
  # @param [Hash] args
  # @return [void]
  def validate_args(args)
    blank_keys = args.select { |_key, value| value.blank? }.keys

    raise(ArgumentError, "#{blank_keys} must not be blank") unless blank_keys.empty?
  end
end
