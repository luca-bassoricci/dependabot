# frozen_string_literal: true

module DependabotServices
  class MergeRequestCreator < ApplicationService
    MR_OPTIONS = %i[
      custom_labels
      commit_message_options
      branch_name_separator
      branch_name_prefix
      milestone
    ].freeze

    # @param [Dependabot::FileFetchers::Base] fetcher
    # @param [Dependabot::Dependency] dependency
    # @param [Hash] opts
    # @param [Array<Number>] assignees
    def initialize(fetcher:, dependency:, **opts)
      @fetcher = fetcher
      @dependency = dependency
      @options = opts
    end

    # Create merge request
    def call
      return unless updated_dependencies

      Dependabot::PullRequestCreator.new(
        source: fetcher.source,
        base_commit: fetcher.commit,
        dependencies: updated_dependencies,
        files: updated_files,
        credentials: Credentials.call,
        **mr_opts
      ).create
    end

    private

    attr_reader :fetcher, :dependency, :options

    def assignees
      return unless options[:assignees]

      Gitlab::UserFinder.call(options[:assignees])
    end

    def reviewers
      return unless options[:reviewers]

      Gitlab::UserFinder.call(options[:reviewers])
    end

    def mr_opts
      {
        assignees: assignees,
        reviewers: { approvers: reviewers },
        label_language: true,
        **options.select { |key, _value| MR_OPTIONS.include?(key) }
      }
    end

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
