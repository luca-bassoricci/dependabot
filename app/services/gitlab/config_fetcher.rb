# frozen_string_literal: true

module Gitlab
  class ConfigFetcher < ApplicationService
    def initialize(repo)
      @repo = repo
    end

    def call
      default_branch = gitlab.project(@repo).default_branch
      gitlab.file_contents(@repo, ".gitlab/dependabot.yml", default_branch)
    end
  end
end
