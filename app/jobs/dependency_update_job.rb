# frozen_string_literal: true

# Dependency update job
#
class DependencyUpdateJob < ApplicationJob
  queue_as :default

  sidekiq_options retry: AppConfig.sidekiq_retry

  # Perform dependency updates and merge request creation
  #
  # @param [Hash] args
  # @return [Array]
  def perform(args)
    symbolized_args = args.symbolize_keys
    @project_name, @package_ecosystem, @directory = symbolized_args
                                                    .slice(:project_name, :package_ecosystem, :directory)
                                                    .values

    execute { Dependabot::UpdateService.call(symbolized_args) }

    UpdateFailures.fetch
  rescue StandardError => e
    capture_error(e)
    raise
  ensure
    save_execution_details
  end

  private

  attr_reader :project_name, :package_ecosystem, :directory

  # Update job
  #
  # @return [Update::Job]
  def update_job
    @update_job ||= Project.find_or_initialize_by(name: project_name)
                           .update_jobs
                           .find_or_initialize_by(
                             package_ecosystem: package_ecosystem,
                             directory: directory
                           )
  end

  # Dependency update run
  #
  # @return [Update::Run]
  def update_run
    @update_run ||= Update::Run.create!(
      job: update_job
    )
  end
  alias_method :create_update_run, :update_run

  # Execute dependency updates
  #
  # @return [void]
  def execute(&block)
    create_update_run unless AppConfig.standalone?

    run_within_context(job_execution_context, &block)
  end

  # Persist execution errors
  #
  # @return [void]
  def save_execution_details
    return if AppConfig.standalone?

    update_run.save_errors!(UpdateFailures.fetch)
    update_run.save_log_entries!(UpdateLogs.fetch)
  end

  # Dependency update execution context
  #
  # @return [String]
  def job_execution_context
    return unless project_name && package_ecosystem && directory

    {
      job: "dep-update",
      project: project_name,
      ecosystem: package_ecosystem,
      directory: directory == "/" ? nil : directory
    }.compact
  end
end
