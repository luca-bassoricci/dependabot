# frozen_string_literal: true

module ApplicationHelper
  # Get gitlab client
  #
  # @return [Gitlab::Client]
  def gitlab
    @gitlab ||= Gitlab::ClientWithRetry.new
  end

  # Log error message and backtrace
  #
  # @param [StandardError] error
  # @return [void]
  def log_error(error)
    Sentry.capture_exception(error)
    log(:error, error.message)
    log(:debug, error.backtrace.join("\n")) if error.backtrace
  end

  # Save dependency update error
  #
  # @param [StandardError] error
  # @return [void]
  def capture_error(error)
    UpdateFailures.save_error(error)
  end

  # Log tagged message with dependency context
  #
  # @param [Symbol] level
  # @param [String, Proc] message
  # @param [String] tag
  # @return [void]
  def log(level, message, tag = nil)
    logger = proc { Rails.logger.send(level, message.is_a?(Proc) ? message.call : message) }
    tags = [execution_context, tag].compact
    tags.empty? ? logger.call : Rails.logger.tagged(tags, &logger)
  end

  # All project cron jobs
  #
  # @param [String] project_name
  # @return [Array<Sidekiq::Cron::Job>]
  def all_project_jobs(project_name)
    Sidekiq::Cron::Job.all.select { |job| job.name.match?(/^#{project_name}:.*/) }
  end

  # Current job execution context
  #
  # @return [String]
  def execution_context
    Thread.current[:context]
  end

  # Set current job execution context
  #
  # @param [String] context
  # @return [void]
  def set_execution_context(context) # rubocop:disable Naming/AccessorMethodName
    Thread.current[:context] = context
  end

  # Clear current job execution context
  # Sidekiq can reuse threads, should be cleared in case next job doesn't reset it
  #
  # @return [void]
  def clear_execution_context
    Thread.current[:context] = nil
  end

  module_function :gitlab,
                  :log,
                  :log_error,
                  :execution_context
end
