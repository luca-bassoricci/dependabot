# frozen_string_literal: true

module Dependabot
  class DependabotSource < ApplicationService
    attr_reader :repo, :directory, :branch

    def initialize(repo:, directory:, branch:)
      @repo = repo
      @directory = directory
      @branch = branch
    end

    def call
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
