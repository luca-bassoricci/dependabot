# frozen_string_literal: true

module Dependabot
  class DependabotSource < ApplicationService
    attr_reader :repo, :directory, :branch

    # @param [String] repo
    # @param [String] directory
    # @param [String] branch
    def initialize(repo:, directory:, branch:)
      @repo = repo
      @directory = directory
      @branch = branch
    end

    # Get dependabot source
    #
    # @return [Dependabot::Source]
    def call
      Dependabot::Source.new(
        provider: "gitlab",
        hostname: URI(AppConfig.gitlab_url).host,
        api_endpoint: "#{AppConfig.gitlab_url}/api/v4",
        repo: repo,
        directory: directory,
        branch: branch
      )
    end
  end
end
