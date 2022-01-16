# frozen_string_literal: true

describe Gitlab::MergeRequest::Updater, epic: :services, feature: :gitlab do
  subject(:updater) do
    described_class.call(
      fetcher: fetcher,
      updated_files: updated_files,
      merge_request: mr,
      target_project_id: nil,
      recreate: recreate
    )
  end

  include_context "with dependabot helper"
  include_context "with webmock"

  let(:pr_updater) { instance_double("Dependabot::PullRequestUpdater", update: nil) }
  let(:gitlab) { instance_double("Gitlab::Client", rebase_merge_request: nil) }

  let(:mr) do
    Gitlab::ObjectifiedHash.new(
      project_id: 1,
      web_url: "mr-url",
      iid: 1,
      sha: "5f92cc4d9939",
      has_conflicts: has_conflicts,
      references: { short: "!1" }
    )
  end

  let(:updater_args) do
    {
      source: fetcher.source,
      base_commit: fetcher.commit,
      old_commit: mr.sha,
      files: updated_files,
      credentials: Dependabot::Credentials.call,
      pull_request_number: mr.iid,
      provider_metadata: { target_project_id: nil }
    }
  end

  before do
    stub_gitlab

    allow(Gitlab).to receive(:client) { gitlab }
    allow(Dependabot::PullRequestUpdater).to receive(:new) { pr_updater }
  end

  context "with mr conflicts" do
    let(:has_conflicts) { true }
    let(:recreate) { false }

    it "recreates mr" do
      updater

      expect(Dependabot::PullRequestUpdater).to have_received(:new).with(**updater_args)
      expect(pr_updater).to have_received(:update)
    end
  end

  context "with explicit recreate option" do
    let(:has_conflicts) { false }
    let(:recreate) { true }

    it "recreates mr" do
      updater

      expect(Dependabot::PullRequestUpdater).to have_received(:new).with(**updater_args)
      expect(pr_updater).to have_received(:update)
    end
  end

  context "without conflicts and recreate option" do
    let(:has_conflicts) { false }
    let(:recreate) { false }

    it "rebases mr" do
      updater

      expect(pr_updater).not_to have_received(:update)
      expect(gitlab).to have_received(:rebase_merge_request).with(mr.project_id, mr.iid)
    end
  end
end
