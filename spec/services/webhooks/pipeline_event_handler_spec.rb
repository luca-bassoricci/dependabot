# frozen_string_literal: true

describe Webhooks::PipelineEventHandler, integration: true, epic: :services, feature: :webhooks do
  include_context "with dependabot helper"

  let(:gitlab) { instance_double("Gitlab::Client", accept_merge_request: nil) }

  let(:project_name) { repo }
  let(:auto_merge) { true }
  let(:mr_iid) { 1 }

  let(:project) { Project.new(name: project_name, configuration: Configuration.new(updates: updates_config)) }

  let(:merge_request) do
    MergeRequest.new(
      project: project,
      iid: mr_iid,
      auto_merge: auto_merge,
      package_ecosystem: "bundler",
      directory: "/",
      state: "opened",
      update_from: "test-0.1"
    )
  end

  # rubocop:disable Metrics/ParameterLists
  def event_result(
    name: project_name,
    iid: mr_iid,
    source: "merge_request_event",
    status: "success",
    merge: "can_be_merged",
    target_project_id: 1
  )
    described_class.call(
      source: source,
      status: status,
      project_name: name,
      mr_iid: iid,
      merge_status: merge,
      source_project_id: 1,
      target_project_id: target_project_id
    )
  end
  # rubocop:enable Metrics/ParameterLists

  before do
    project.save!
    merge_request.save!

    allow(Gitlab::Client).to receive(:new) { gitlab }
  end

  context "with actionable conditions" do
    it "accepts merge request" do
      expect(event_result).to eq({ merge_request_accepted: true })
      expect(gitlab).to have_received(:accept_merge_request).with(project_name, mr_iid)
    end
  end

  context "with non actionable conditions" do
    it "skips merge if project is not registered" do
      expect(event_result(name: "doesnt_exist")).to eq(nil)
    end

    it "skips merge if mr is not found" do
      expect(event_result(iid: 333)).to eq(nil)
    end

    it "skips merge if pipeline is not successful" do
      expect(event_result(status: "failed")).to eq(nil)
    end

    it "skips merge if pipeline is not merge request event" do
      expect(event_result(source: "branch")).to eq(nil)
    end

    it "skips merge if mr cannot be merged" do
      expect(event_result(merge: "cannot_be_merged")).to eq(nil)
    end

    it "skips merge if forked mr pipeline" do
      expect(event_result(target_project_id: 2)).to eq(nil)
    end
  end

  context "with auto_merge: false" do
    let(:auto_merge) { false }

    it "skips merge" do
      expect(event_result).to eq(nil)
    end
  end
end
