# frozen_string_literal: true

module Gitlab
  module Vulnerabilities
    class IssueCloser < ApplicationService
      # Vulnerability issue closer
      #
      # @param [VulnerabilityIssue] vulnerability_issue
      def initialize(vulnerability_issue)
        @vulnerability_issue = vulnerability_issue
      end

      def call
        log(:debug, "Closing obsolete vulnerability issue !#{iid}")
        gitlab.close_issue(project.name, iid)
        vulnerability_issue.close
      end

      private

      attr_reader :vulnerability_issue

      delegate :iid, :project, to: :vulnerability_issue
    end
  end
end
