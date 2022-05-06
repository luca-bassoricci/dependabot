# frozen_string_literal: true

module Api
  class NotifyReleaseController < ApplicationController
    # Trigger specific dependency updates
    #
    # @return [void]
    def create
      @name, @package_ecosystem = params.require(%i[name package_ecosystem])
      return bad_request if configurations.empty?

      NotifyReleaseJob.perform_later(name, package_ecosystem, configurations)
      json_response(body: { triggered: true })
    end

    private

    attr_reader :name, :package_ecosystem

    # Handle bad request
    #
    # @return [void]
    def bad_request
      json_response(
        status: 400,
        body: {
          status: 400,
          error: "No projects with configured '#{package_ecosystem}' found"
        }
      )
    end

    # Project configurations
    #
    # @return [Array<Hash<Symbol, String>>]
    def configurations
      @configurations ||= ::Project.all.map do |project|
        configs = project.configuration&.entries(package_ecosystem: package_ecosystem)
        next if configs.blank?

        configs.map { |conf| { project_name: project.name, directory: conf[:directory] } }
      end.flatten.compact
    end
  end
end
