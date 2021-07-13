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

  # Log tagged message with dependency context
  #
  # @param [Symbol] level
  # @param [String] message
  # @param [String] tag
  # @return [void]
  def log(level, message, tag = nil)
    logger = proc { Rails.logger.send(level, message) }
    tags = [Thread.current[:context], tag].compact
    tags.empty? ? logger.call : Rails.logger.tagged(tags, &logger)
  end

  # All project cron jobs
  #
  # @return [Array<Sidekiq::Cron::Job>]
  def all_project_jobs(project)
    Sidekiq::Cron::Job.all.select { |job| job.name.match?(/^#{project}:.*/) }
  end

  module_function :gitlab, :log, :log_error
end
