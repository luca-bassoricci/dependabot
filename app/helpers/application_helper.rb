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
  # @param [StndardError] error
  # @return [void]
  def log_error(error)
    Rails.logger.tap do |logger|
      logger.error { error.message }
      logger.debug { error.backtrace.join("\n") } if error.backtrace
    end
  end

  # Save dependency update error
  #
  # @param [StandardError] error
  # @return [void]
  def capture_error(error)
    UpdateFailures.call.save_error(error)
  end

  # Log tagged message with dependency context
  #
  # @param [Symbol] level
  # @param [String] message
  # @param [String] tag
  # @return [void]
  def log(level, message, tag = nil)
    logger = proc { Rails.logger.send(level, message) }
    tags = [execution_context, tag].compact
    tags.empty? ? logger.call : Rails.logger.tagged(tags, &logger)
  end

  # All project cron jobs
  #
  # @return [Array<Sidekiq::Cron::Job>]
  def all_project_jobs(project)
    Sidekiq::Cron::Job.all.select { |job| job.name.match?(/^#{project}:.*/) }
  end

  # Current execution context - project_name + package_ecosystem + directory
  #
  # @return [String]
  def execution_context
    Thread.current[:context]
  end

  # Get execution context name
  #
  # @param [Hash] job_args
  # @return [String]
  def execution_context_name(args)
    context = args.values_at("project_name", "package_ecosystem", "directory")
    context.pop if context.last == "/"

    context.join("=>")
  end

  module_function :gitlab,
                  :log,
                  :log_error,
                  :execution_context,
                  :execution_context_name
end
