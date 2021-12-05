# frozen_string_literal: true

class NotifyReleaseJob < ApplicationJob
  queue_as :hooks

  # Trigger package updates
  #
  # @param [String] name
  # @param [String] package_ecosystem
  # @param [Array<Hash>] configs
  # @return [void]
  def perform(name, package_ecosystem, configs)
    configs.each do |config|
      log(:info, "Triggering updates for '#{package_ecosystem}' package '#{name}' in '#{config[:project_name]}'")
      Dependabot::UpdateService.call(
        dependency_name: name,
        package_ecosystem: package_ecosystem,
        **config
      )
    end
  end
end
