# frozen_string_literal: true

class UpdateFailures < ApplicationService
  def call
    self
  end

  delegate :save!, to: :job_errors

  # Reset saved run errors
  #
  # @return [void]
  def reset_errors
    return if AppConfig.standalone? || !execution_context

    job_errors.run_errors = []
    job_errors.save!
  end

  # Capture update job error
  #
  # @param [Error] error
  # @return [void]
  def save_error(error)
    return if AppConfig.standalone? || !execution_context

    job_errors.run_errors.push(error.message)
    job_errors.save!
  end

  private

  # Job errors object
  #
  # @return [JobErrors]
  def job_errors
    @job_errors ||= JobErrors.where(name: execution_context).first || JobErrors.new(name: execution_context)
  end
end
