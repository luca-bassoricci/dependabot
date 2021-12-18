# frozen_string_literal: true

class DependencyUpdateJob < ApplicationJob
  queue_as :default

  sidekiq_options retry: AppConfig.sidekiq_retry

  # Perform dependency updates and merge request creation
  #
  # @param [Hash] args
  # @return [Array]
  def perform(args)
    @project, @package_ecosystem, @directory = args.slice("project_name", "package_ecosystem", "directory").values
    @update_failures = UpdateFailures.call

    reset_errors
    save_execution_context
    save_execution_time

    Dependabot::UpdateService.call(args.symbolize_keys)

    update_failures.errors
  rescue StandardError => e
    capture_error(e)
    raise
  ensure
    save_execution_details
  end

  private

  attr_reader :project, :package_ecosystem, :directory, :update_failures

  # Update job
  #
  # @return [UpdateJob]
  def update_job
    @update_job ||= Project.find_or_initialize_by(name: project)
                           .update_jobs
                           .find_or_initialize_by(
                             package_ecosystem: package_ecosystem,
                             directory: directory
                           )
  end

  # Reset execution errors
  #
  # @return [void]
  def reset_errors
    update_failures.reset
  end

  # Persist execution errors
  #
  # @return [void]
  def save_execution_details
    return if AppConfig.standalone?

    update_job.run_errors = update_failures.errors
    update_job.save!
  end

  # Set dependency update execution context
  #
  # @return [void]
  def save_execution_context
    return unless project && package_ecosystem && directory

    context_values = [project, package_ecosystem]
    context_values << directory unless directory == "/"

    Thread.current[:context] = context_values.join("=>")
  end

  # Save last enqued time
  #
  # @return [void]
  def save_execution_time
    return if AppConfig.standalone?

    update_job.last_executed = DateTime.now.utc
  end
end
