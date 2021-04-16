# frozen_string_literal: true

describe Webhooks::MergeRequestEventHandler, integration: true, epic: :services, feature: :webhooks do
  include_context "with dependabot helper"

  let(:project) { Project.new(name: repo, config: dependabot_config) }
  let(:merge_request) do
    MergeRequest.new(
      project: project,
      iid: 1,
      package_manager: "bundler",
      state: "opened",
      auto_merge: false,
      dependencies: "test"
    )
  end

  before do
    project.save!
    merge_request.save!

    allow(Rails.logger).to receive(:error)
  end

  it "closes saved mr" do
    aggregate_failures do
      expect(described_class.call(repo, 1)).to eq({ closed_merge_request: true })
      expect(merge_request.reload.state).to eq("closed")
    end
  end

  it "skips non existing mrs" do
    expect(described_class.call(repo, 2)).to be_nil
  end
end
