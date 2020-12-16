# frozen_string_literal: true

describe Gitlab::MergeRequestUpdater do
  include_context "with dependabot helper"
  include_context "with webmock"

  let(:pr_updater) { instance_double("Dependabot::PullRequestUpdater", update: nil) }
  let(:mr) do
    OpenStruct.new(
      web_url: "mr-url",
      iid: 1,
      sha: "5f92cc4d9939",
      has_conflicts: has_conflicts,
      references: OpenStruct.new(short: "!1")
    )
  end

  before do
    stub_gitlab

    allow(Dependabot::PullRequestUpdater).to receive(:new) { pr_updater }
  end

  context "when merge request has conflicts" do
    let(:has_conflicts) { true }

    it "performs rebase" do
      described_class.call(fetcher: fetcher, updated_files: updated_files, merge_request: mr)

      expect(Dependabot::PullRequestUpdater).to have_received(:new).with(
        source: fetcher.source,
        base_commit: fetcher.commit,
        old_commit: mr.sha,
        files: updated_files,
        credentials: Credentials.fetch,
        pull_request_number: mr.iid
      )
    end
  end

  context "when merge request has no conflicts" do
    let(:has_conflicts) { false }

    it "skips rebase" do
      described_class.call(fetcher: fetcher, updated_files: updated_files, merge_request: mr)

      expect(Dependabot::PullRequestUpdater).not_to have_received(:new)
    end
  end
end
