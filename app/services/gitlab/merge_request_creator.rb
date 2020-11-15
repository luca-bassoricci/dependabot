# frozen_string_literal: true

module Gitlab
  class MergeRequestCreator < ApplicationService
    # @param [Dependabot::FileFetchers::Base] fetcher
    # @param [Array<Dependabot::Dependency>] updated_dependencies
    # @param [Array<Dependabot::DependencyFile>] updated_files
    # @param [Hash] mr_options
    def initialize(fetcher:, updated_dependencies:, updated_files:, mr_options:)
      @fetcher = fetcher
      @updated_dependencies = updated_dependencies
      @updated_files = updated_files
      @mr_options = mr_options
    end

    # Create merge request
    #
    # @return [Gitlab::ObjectifiedHash]
    def call
      Dependabot::PullRequestCreator.new(
        source: fetcher.source,
        base_commit: fetcher.commit,
        dependencies: updated_dependencies,
        files: updated_files,
        credentials: Credentials.fetch,
        **mr_options
      ).create.tap { |mr| logger.info { "created mr #{mr.web_url}" } if mr }
    rescue Octokit::TooManyRequests
      logger.error { "github API rate limit exceeded! See: https://developer.github.com/v3/#rate-limiting" }
    end

    private

    attr_reader :fetcher, :updated_dependencies, :updated_files, :mr_options
  end
end
