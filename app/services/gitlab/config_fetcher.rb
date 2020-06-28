# frozen_string_literal: true

module Gitlab
  class ConfigFetcher < ApplicationService
    def initialize(repo)
      @repo = repo
    end

    def call
      default_branch = gitlab.project(@repo).default_branch

      logger.info { "Fetching configuration for #{repo} from #{default_branch}" }
      gitlab.file_contents(@repo, ".gitlab/dependabot.yml", default_branch)
    end

    private

    attr_reader :repo
  end
end
