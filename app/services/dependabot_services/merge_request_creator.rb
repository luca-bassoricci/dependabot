# frozen_string_literal: true

module DependabotServices
  class MergeRequestCreator < ApplicationService
    attr_reader :source, :fetcher, :dependency, :assignees

    # @param [Dependabot::Source] source
    # @param [String] base_commit
    # @param [Dependabot::Dependency] dependency
    # @param [Array<Dependabot::DependencyFile>] files
    # @param [Array<Number>] assignees
    def initialize(source:, fetcher:, dependency:, assignees: [nil])
      @source = source
      @dependency = dependency
      @fetcher = fetcher
      @assignees = assignees
    end

    # Create merge request
    def call
      return unless updated_dependencies

      Dependabot::PullRequestCreator.new(
        source: source,
        base_commit: fetcher.commit,
        dependencies: updated_dependencies,
        files: updated_files,
        credentials: Credentials.call,
        assignees: assignees,
        label_language: true
      ).create
    end

    private

    # @return [Array<Dependabot::Dependency>]
    def updated_dependencies
      @updated_dependencies ||= DependabotServices::UpdateChecker.call(
        dependency: dependency,
        dependency_files: fetcher.files
      )
    end

    # @return [Array<Dependabot::DependencyFile>]
    def updated_files
      @updated_files ||= DependabotServices::FileUpdater.call(
        dependencies: updated_dependencies,
        dependency_files: fetcher.files
      )
    end
  end
end
