# frozen_string_literal: true

class DependencyUpdateJob < ApplicationJob
  queue_as :default

  sidekiq_options retry: AppConfig.sidekiq_retry

  # Perform dependency updates and merge request creation
  #
  # @param [Hash] args
  # @return [void]
  def perform(args)
    symbolized_args = args.symbolize_keys

    save_execution_context(symbolized_args)
    save_execution_time(symbolized_args)
    UpdateFailures.call.reset_errors

    Dependabot::UpdateService.call(symbolized_args)
  rescue StandardError => e
    capture_error(e)
    raise
  ensure
    reset_execution_context
  end

  private

  # Set dependency update execution context
  #
  # @param [Hash] args
  # @return [void]
  def save_execution_context(args)
    return unless args

    context_values = args[:directory] == "/" ? args.values_at(:project_name, :package_ecosystem) : args.values
    Thread.current[:context] = args.dup.merge({ name: context_values.join("=>") })
  end

  # Reset execution context
  #
  # @return [void]
  def reset_execution_context
    Thread.current[:context] = nil
  end

  # Save last enqued time
  #
  # @param [Hash] args
  # @return [void]
  def save_execution_time(args)
    return if AppConfig.standalone?

    Project
      .find_by(name: args[:project_name]).update_jobs
      .find_or_create_by(package_ecosystem: args[:package_ecosystem], directory: args[:directory])
      .update_attributes!(last_executed: DateTime.now.utc)
  end
end
