# frozen_string_literal: true

# :reek:TooManyStatements
class DependencyUpdateJob < ApplicationJob
  queue_as :default

  sidekiq_options retry: AppConfig.sidekiq_retry

  # Perform dependency updates and merge request creation
  #
  # @param [Hash] args
  # @return [Array]
  def perform(args)
    symbolized_args = args.symbolize_keys
    @project, @package_ecosystem, @directory = symbolized_args
                                               .slice(:project_name, :package_ecosystem, :directory)
                                               .values

    execute { Dependabot::UpdateService.call(symbolized_args) }

    UpdateFailures.errors
  rescue StandardError => e
    capture_error(e)
    raise
  ensure
    save_execution_details
  end

  private

  attr_reader :project, :package_ecosystem, :directory

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

  # Execute dependency updates
  #
  # @return [void]
  def execute(&block)
    unless AppConfig.standalone?
      reset_execution_details
      save_execution_time
    end

    run_within_context(job_execution_context, &block)
  end

  # Save last enqued time
  #
  # @return [void]
  def save_execution_time
    update_job.last_executed = DateTime.now.utc
  end

  def reset_execution_details
    UpdateFailures.reset
    UpdateLog.reset
  end

  # Persist execution errors
  #
  # @return [void]
  def save_execution_details
    return if AppConfig.standalone?

    update_job.run_errors = UpdateFailures.errors
    update_job.run_log = UpdateLog.log
    update_job.save!
  end

  # Dependency update execution context
  #
  # @return [String]
  def job_execution_context
    return unless project && package_ecosystem && directory

    context_values = [project, package_ecosystem]
    context_values << directory unless directory == "/"

    "dependency-update: #{context_values.join('=>')}"
  end
end
