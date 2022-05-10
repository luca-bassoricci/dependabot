# frozen_string_literal: true

module Webhooks
  class IssueEventHandler < ApplicationService
    # Close existing vulnerability issue
    #
    # @param [String] project_name
    # @param [Integer] issue_iid
    # @param [String] action
    def initialize(project_name:, issue_iid:)
      @project_name = project_name
      @issue_iid = issue_iid
    end

    def call
      return unless vulnerability_issue

      vulnerability_issue.close
    end

    private

    attr_reader :project_name, :issue_iid

    # Open vulnerability issue
    #
    # @return [VulnerabilityIssue]
    def vulnerability_issue
      @vulnerability_issue ||= Project.find_by(name: project_name)
                                      .vulnerability_issues
                                      .find_by(
                                        iid: issue_iid,
                                        status: "opened"
                                      )
    rescue Mongoid::Errors::DocumentNotFound
      false
    end
  end
end
