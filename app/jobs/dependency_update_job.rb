# frozen_string_literal: true

class DependencyUpdateJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 2

  # Perform dependency updates and merge request creation
  # @param [Hash] args
  # @return [void]
  def perform(args)
    DependencyUpdater.call(args)
  end
end
