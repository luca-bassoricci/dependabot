# frozen_string_literal: true

module DependabotServices
  class MergeRequestCreator < ApplicationService
    # Get merge request creator
    # @param [Hash] params
    # @option params [Dependabot::Source] :source
    # @option params [String] :base_commit
    # @option params [Array<Dependabot::Dependency>] :dependencies
    # @option params [Array<Dependabot::DependencyFile>] :files
    # @option params [Array<Number>] assignees
    # @return [Dependabot::PullRequestCreator]
    def call(**params)
      Dependabot::PullRequestCreator.new(
        source: params[:source],
        base_commit: params[:base_commit],
        dependencies: params[:dependencies],
        files: params[:files],
        credentials: Credentials.call,
        assignees: params[:assignees] || [nil],
        label_language: true
      )
    end
  end
end
