# frozen_string_literal: true

require_relative "util"

class IssueTriageHelper
  using Rainbow

  Rainbow.enabled = true

  BOT_USERNAME = "dependabot-bot"
  STALE_LABEL = "stale"
  STALE_INTERVAL = 30
  CLOSE_INTERVAL = 7

  def self.call
    new.triage_issues
  end

  # Triage project issues
  #
  # @return [void]
  def triage_issues
    update_issues
    update_stale_issues

    logger.info("Finished processing stale issues!".green)
  end

  private

  include Util

  # Mark issues as stale if no updates received
  #
  # @return [void]
  def update_issues
    issues.each { |issue| mark_issue_stale(issue) }
  end

  # Close stale issues or remove stale label if updates received
  #
  # @return [void]
  def update_stale_issues
    stale_issues.each { |issue| update_stale_issue(issue) }
  end

  # Issues applicable for being marked as stale
  #
  # @return [Array<Gitlab::ObjectifiedHash>]
  def issues
    @issues ||= gitlab.issues(
      project_name,
      state: "opened",
      not: {
        labels: "feature,improvement,bug"
      }
    )
  end

  # Stale issues
  #
  # @return [Array<Gitlab::ObjectifiedHash>]
  def stale_issues
    @stale_issues ||= gitlab.issues(
      project_name,
      state: "opened",
      labels: STALE_LABEL
    )
  end

  # Mark issue as stale
  #
  # @param [Gitlab::ObjectifiedHash] issue
  # @return [void]
  def mark_issue_stale(issue)
    return unless last_updated(issue) > STALE_INTERVAL

    add_stale_label(issue)
    add_comment(issue.iid, <<~NOTE)
      This issue is marked as stale becaues it has not received any updates in more than #{STALE_INTERVAL} days!

      This issue will be closed automatically if not updated in #{CLOSE_INTERVAL} days!
    NOTE
  end

  # Close stale issue
  #
  # @param [Gitlab::ObjectifiedHash] issue
  # @return [void]
  def update_stale_issue(issue)
    issue_iid = issue.iid

    return remove_stale_label(issue) unless last_updated_by_bot(issue_iid)
    return unless last_updated(issue) > CLOSE_INTERVAL

    logger.info("Closing stale issue #{issue.web_url.bright}")
    add_comment(issue_iid, <<~NOTE.strip)
      This issue is automatically closed because it has not received any updates for #{CLOSE_INTERVAL} days since being marked as stale!

      #{issue.labels.any? { |label| label.include?('dependabot-core') } ? core_close_note : ''}
    NOTE
    gitlab.close_issue(project_name, issue_iid)
  end

  # Add stale label to issue
  #
  # @param [Gitlab::ObjectifiedHash] issue
  # @return [void]
  def add_stale_label(issue)
    logger.info("Marking issue #{issue.web_url.bright} as stale")
    gitlab.edit_issue(project_name, issue.iid, labels: "#{issue.labels.join(',')},#{STALE_LABEL}")
  end

  # Remove stale label from issue
  #
  # @param [Gitlab::ObjectifiedHash] issue
  # @return [void]
  def remove_stale_label(issue)
    logger.info("Removing stale label for issue #{issue.web_url.bright}")
    gitlab.edit_issue(project_name, issue.iid, remove_labels: STALE_LABEL)
  end

  # Issue last updated by dependabot-bot user
  #
  # @param [Integer] issue_iid
  # @return [Boolean]
  def last_updated_by_bot(issue_iid)
    last_author = gitlab
                  .issue_notes(project_name, issue_iid, sort: "asc")
                  .auto_paginate
                  .reject { |note| note.system } # rubocop:disable Style/SymbolProc
                  .last
                  .to_h
                  .dig("author", "username")

    last_author == BOT_USERNAME
  end

  # Add comment to the issue
  #
  # @param [Integer] issue_iid
  # @param [String] note
  # @return [void]
  def add_comment(issue_iid, note)
    gitlab.create_issue_note(project_name, issue_iid, note)
  end

  # Issue last update in days
  #
  # @param [Gitlab::ObjectifiedHash] issue
  # @return [Integer]
  def last_updated(issue)
    (Date.today - Date.parse(issue.updated_at)).to_i # rubocop:disable Rails/Date
  end

  # Additional info on dependabot-core issue closure
  #
  # @return [String]
  def core_close_note
    <<~NOTE
      This issue has been marked as problem with `dependabot-core`.
      Please consult [dependabot-core issue](https://github.com/dependabot/dependabot-core/issues) tracker for possible solutions.
    NOTE
  end

  # Project name
  #
  # @return [String]
  def project_name
    @project_name ||= ENV["CI_PROJECT_PATH"]
  end
end
