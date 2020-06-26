# frozen_string_literal: true

class DependencyUpdateJob < ApplicationJob
  queue_as :default

  # Perform dependency updates and merge request creation
  # @param [Hash] args
  # @return [void]
  def perform(args)
    DependencyUpdater.call(args)
  end
end
