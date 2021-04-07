# frozen_string_literal: true

class DependencyUpdateJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 2

  # Perform dependency updates and merge request creation
  #
  # @param [Hash] args
  # @return [void]
  def perform(args)
    context = args.values_at("repo", "package_ecosystem", "directory")
    context.pop if context.last == "/"
    # Save context for tagged logger
    Thread.current[:context] = context.join("=>")

    Dependabot::UpdateService.call(args)
  end
end
