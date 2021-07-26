# frozen_string_literal: true

describe Webhooks::MergeRequestEventHandler, integration: true, epic: :services, feature: :webhooks do
  include ActiveJob::TestHelper

  include_context "with dependabot helper"

  let(:config) { dependabot_config.first }
  let(:args) { { project_name: repo, mr_iid: 1, action: "close" } }
  let(:project) { Project.new(name: repo, config: dependabot_config) }
  let(:merge_request) do
    MergeRequest.new(
      project: project,
      directory: config[:directory],
      iid: 1,
      package_ecosystem: config[:package_ecosystem],
      state: "opened",
      auto_merge: false,
      dependencies: "test"
    )
  end
  let(:open_merge_request) do
    MergeRequest.new(
      project: project,
      directory: config[:directory],
      iid: 3,
      package_ecosystem: config[:package_ecosystem],
      state: "opened",
      auto_merge: false,
      dependencies: "test"
    )
  end
  let(:other_open_merge_request) do
    MergeRequest.new(
      project: project,
      directory: "/frontend",
      iid: 4,
      package_ecosystem: "npm",
      state: "opened",
      auto_merge: false,
      dependencies: "test"
    )
  end

  before do
    project.save!
    merge_request.save!
  end

  context "without update trigger" do
    it "closes saved mr" do
      result = described_class.call(**args)

      aggregate_failures do
        expect(result).to eq({ closed_merge_request: true })
        expect(merge_request.reload.state).to eq("closed")
      end
    end

    it "skips non existing mrs" do
      expect(described_class.call(**args, mr_iid: 2)).to be_nil
    end
  end

  context "with update trigger" do
    before do
      open_merge_request.save!
      other_open_merge_request.save!
    end

    it "closes saved mr and triggers update of open mrs for same package_ecosystem" do
      ActiveJob::Base.queue_adapter = :test

      expect { described_class.call(**args, action: "merge") }.to have_enqueued_job(MergeRequestUpdateJob)
        .on_queue("hooks")
        .with(repo, open_merge_request.iid)
    end
  end
end
