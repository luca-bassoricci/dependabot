# frozen_string_literal: true

module Webhooks
  # :reek:InstanceVariableAssumption
  class PushEventHandler < ApplicationService
    # @param [String] project
    # @param [Array] commits
    def initialize(project_name:, commits:)
      @project_name = project_name
      @commits = commits
      @config_filename = DependabotConfig.config_filename
    end

    # Create or delete dependency update jobs
    #
    # @return [Project]
    def call
      return unless modified_config? || deleted_config?
      return clean if deleted_config?

      Dependabot::Projects::Creator.call(project_name)
                                   .tap { |project| Cron::JobSync.call(project) }
                                   .sanitized_hash
    end

    private

    attr_reader :project_name, :commits, :config_filename

    # Has dependabot config been modified
    #
    # @return [Boolean]
    def modified_config?
      commits.any? do |commit|
        commit.values_at(:added, :modified).flatten.include?(config_filename)
      end
    end

    # Has dependabot config been deleted
    #
    # @return [Boolean]
    def deleted_config?
      return @deleted_config if defined?(@deleted_config)

      @deleted_config = commits.any? do |commit|
        commit[:removed].include?(config_filename)
      end
    end

    # Clean up after removing config
    #
    # @return [void]
    def clean
      Dependabot::Projects::Remover.call(project_name)
    end
  end
end
