# frozen_string_literal: true

class MergeRequestRecreationJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 1

  # Perform merge request recreation
  #
  # @param [Hash] args
  # @return [void]
  def perform(*args)
    Dependabot::MergeRequestRecreator.call(*args)
  end
end
