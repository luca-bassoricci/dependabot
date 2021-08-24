# frozen_string_literal: true

class UpdateFailures < ApplicationService
  def call
    self
  end

  # Reset saved run errors
  #
  # @return [void]
  def reset_errors
    return if AppConfig.standalone? || !execution_context

    update_job.run_errors = []
    update_job.save!
  end

  # Capture update job error
  #
  # @param [Error] error
  # @return [void]
  def save_error(error)
    return if AppConfig.standalone? || !execution_context

    update_job.run_errors.push(error.message)
    update_job.save!
  end

  private

  # Current context project
  #
  # @return [Project]
  def project
    @project ||= Project.find_by(name: execution_context[:project_name])
  end

  # Job errors object
  #
  # @return [JobErrors]
  def update_job
    @update_job ||= UpdateJob.find_or_create_by(
      project_id: project._id,
      **execution_context.slice(:package_ecosystem, :directory)
    )
  end
end
