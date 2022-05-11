# frozen_string_literal: true

module Gitlab
  module Vulnerabilities
    class IssueCreator < ApplicationService
      using Rainbow

      # Vulnerability issue creator
      #
      # @param [Project] project_name
      # @param [Vulnerability] vulnerability
      # @param [Dependabot::DependencyFile] dependency_file
      # @param [Array] assignees
      def initialize(project:, vulnerability:, dependency_file:, assignees:)
        @project = project
        @vulnerability = vulnerability
        @dependency_file = dependency_file
        @assignees = Gitlab::UserFinder.call(assignees)
      end

      def call
        return if issue_exists?

        issue = gitlab.create_issue(
          project.name,
          vulnerability.summary,
          description: issue_body,
          labels: "security",
          **assignees_option
        )
        log(:info, "  created security vulnerability issue: #{issue.web_url.bright}")

        VulnerabilityIssue.create(
          iid: issue.iid,
          project: project,
          directory: directory,
          package: name,
          package_ecosystem: vulnerability.package_ecosystem,
          vulnerability: vulnerability
        )
      end

      private

      attr_reader :project, :vulnerability, :dependency_file, :assignees

      delegate :directory, :name, to: :dependency_file

      # Vulnerability issue template
      #
      # @return [String]
      def issue_body
        IssueTemplate.call(vulnerability, dependency_file)
      end

      # Issue already exists
      #
      # @return [Boolean]
      def issue_exists?
        VulnerabilityIssue.find_by(
          project: project,
          directory: directory,
          vulnerability: vulnerability
        )
      rescue Mongoid::Errors::DocumentNotFound
        false
      end

      # Assignees option
      #
      # @return [Hash]
      def assignees_option
        return {} unless assignees

        assignees.size == 1 ? { assignee_id: assignees.first } : { assignee_ids: assignees }
      end
    end
  end
end
