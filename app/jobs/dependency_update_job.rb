# frozen_string_literal: true

class DependencyUpdateJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 2

  # Perform dependency updates and merge request creation
  #
  # @param [Hash] args
  # @return [void]
  def perform(args)
    project_name, package_ecosystem, directory = args.values_at("repo", "package_ecosystem", "directory")
    # Save context for tagged logger
    Thread.current[:context] = "#{project_name}=>#{package_ecosystem}=>#{directory}"

    DependencyUpdater.call(args)
  end
end
