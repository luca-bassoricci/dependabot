# frozen_string_literal: true

require_relative "../task_helpers/issue_triage_helper"

# rubocop:disable Rails/RakeEnvironment
namespace :triage do
  desc "Automatically close stale issues"
  task :update_stale_issues do
    IssueTriageHelper.call
  end
end
# rubocop:enable Rails/RakeEnvironment
