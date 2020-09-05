# frozen_string_literal: true

module Gitlab
  class ConfigFetcher < ApplicationService
    # @param [String] repo
    def initialize(repo)
      @repo = repo
    end

    # Get dependabot.yml file contents
    #
    # @return [String]
    def call
      default_branch = gitlab.project(repo)&.default_branch

      raise("Failed to fetch default branch for #{repo}") unless default_branch

      logger.info { "Fetching configuration for #{repo} from #{default_branch}" }
      gitlab.file_contents(repo, ".gitlab/dependabot.yml", default_branch).tap do |config|
        raise("Failed to fetch configuration for #{repo}") unless config
      end
    rescue Error::NotFound
      raise(Dependabot::ConfigNotFound, ".gitlab/dependabot.yml not present in #{repo}")
    end

    private

    attr_reader :repo
  end
end
