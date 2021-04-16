# frozen_string_literal: true

describe Webhooks::PipelineEventHandler, integration: true, epic: :services, feature: :webhooks do
  include_context "with dependabot helper"

  let(:project_name) { repo }
  let(:auto_merge) { true }
  let(:merge_status) { "can_be_merged" }
  let(:mr_iid) { 1 }
  let(:event_source) { "merge_request_event" }
  let(:pipeline_status) { "success" }

  let(:project) { Project.new(name: project_name) }
  let(:merge_request) do
    MergeRequest.new(
      project: project,
      iid: mr_iid,
      auto_merge: auto_merge,
      package_manager: "bundler",
      state: "opened",
      dependencies: "test"
    )
  end

  def event_result(source: event_source, status: pipeline_status, name: project_name, iid: mr_iid, merge: merge_status)
    described_class.call(source, status, name, iid, merge)
  end

  before do
    project.save!
    merge_request.save!

    allow(Gitlab::MergeRequest::Acceptor).to receive(:call)
  end

  context "with actionable conditions" do
    it "accepts merge request" do
      expect(event_result).to eq({ merge_request_accepted: true })
      expect(Gitlab::MergeRequest::Acceptor).to have_received(:call).with(project_name, mr_iid)
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
  end

  context "with auto_merge: false" do
    let(:auto_merge) { false }

    it "skips merge" do
      expect(event_result).to eq(nil)
    end
  end
end
