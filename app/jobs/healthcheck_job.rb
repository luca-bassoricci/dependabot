# frozen_string_literal: true

class HealthcheckJob < ApplicationJob
  queue_as HealthcheckConfig.queue
  sidekiq_options retry: 0

  # Save temp file to validate sidekiq is functional
  #
  # @return [void]
  def perform
    FileUtils.touch(HealthcheckConfig.filename)
  end
end
