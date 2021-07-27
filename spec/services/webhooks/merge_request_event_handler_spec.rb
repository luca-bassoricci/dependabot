# frozen_string_literal: true

describe Webhooks::MergeRequestEventHandler, integration: true, epic: :services, feature: :webhooks do
  include ActiveJob::TestHelper

  include_context "with dependabot helper"

  let(:config) { dependabot_config.first }
  let(:args) { { project_name: repo, mr_iid: 1, action: action } }
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

  context "with mr close action" do
    let(:action) { "close" }

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

  context "with mr merge action" do
    ActiveJob::Base.queue_adapter = :test

    let(:action) { "merge" }

    before do
      open_merge_request.save!
      other_open_merge_request.save!
    end

    context "with auto-rebase enabled" do
      it "closes saved mr and triggers update of open mrs for same package_ecosystem" do
        expect { described_class.call(**args) }.to have_enqueued_job(MergeRequestUpdateJob)
          .on_queue("hooks")
          .with(repo, open_merge_request.iid)
      end
    end

    context "with auto-rebase disabled" do
      before do
        project.config.first[:rebase_strategy] = "none"
        project.save!
      end

      it "skips update for auto-rebase: none option" do
        expect { described_class.call(**args) }.not_to have_enqueued_job(MergeRequestUpdateJob)
      end
    end
  end
end
