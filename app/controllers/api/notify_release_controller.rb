# frozen_string_literal: true

module Api
  class NotifyReleaseController < ApplicationController
    # Add new project or update existing one and schedule jobs
    #
    # @return [void]
    def create
      name, package_ecosystem = params.require(%i[name package_ecosystem])
      configs = configurations(package_ecosystem)
      return if configs.empty?

      log(:info, "Triggering updates for '#{package_ecosystem}' package '#{name}'")
      configs.each do |config|
        Dependabot::UpdateService.call(
          dependency_name: name,
          package_ecosystem: package_ecosystem,
          **config
        )
      end

      json_response(body: { triggered: true })
    end

    private

    # Project configurations
    #
    # @param [String] package_ecosystem
    # @return [Array<Hash<Symbol, String>>]
    def configurations(package_ecosystem)
      ::Project.all.map do |project|
        configs = project.config.select { |conf| conf[:package_ecosystem] == package_ecosystem }
        next if configs.empty?

        configs.map { |conf| { project_name: project.name, directory: conf[:directory] } }
      end.flatten.compact
    end
  end
end
