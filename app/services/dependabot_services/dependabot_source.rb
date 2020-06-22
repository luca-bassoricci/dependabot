# frozen_string_literal: true

module DependabotServices
  class DependabotSource < ApplicationService
    # Get dependabot source
    # @param [String] repo
    # @param [String] directory
    # @param [String] branch
    # @return [Dependabot::Source]
    def call(repo, directory = ".", branch = "master")
      Dependabot::Source.new(
        provider: "gitlab",
        hostname: Settings.gitlab_hostname,
        api_endpoint: "https://#{Settings.gitlab_hostname}/api/v4",
        repo: repo,
        directory: directory,
        branch: branch
      )
    end
  end
end
