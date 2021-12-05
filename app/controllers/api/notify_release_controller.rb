# frozen_string_literal: true

module Api
  class NotifyReleaseController < ApplicationController
    # Trigger specific dependency updates
    #
    # @return [void]
    def create
      name, package_ecosystem = params.require(%i[name package_ecosystem])
      configs = configurations(package_ecosystem)
      return if configs.empty?

      NotifyReleaseJob.perform_later(name, package_ecosystem, configs)

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
