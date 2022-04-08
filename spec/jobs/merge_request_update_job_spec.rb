# frozen_string_literal: true

describe MergeRequestUpdateJob, epic: :jobs, feature: "mr update", type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  let(:project_name) { "project" }
  let(:mr_iid) { 1 }
  let(:action) { Dependabot::MergeRequest::UpdateService::UPDATE }

  before do
    allow(Dependabot::MergeRequest::UpdateService).to receive(:call)
  end

  context "with successfull update" do
    it "performs enqued job" do
      perform_enqueued_jobs { job.perform_later(project_name, mr_iid, action) }

      expect(Dependabot::MergeRequest::UpdateService).to have_received(:call).with(
        project_name: project_name,
        mr_iid: mr_iid,
        action: action
      )
    end
  end

  context "with failed update" do
    before do
      allow(Dependabot::MergeRequest::UpdateService).to receive(:call).and_raise("Error")
      allow(Gitlab::MergeRequest::Commenter).to receive(:call)
    end

    it "adds a comment on failed mr update" do
      perform_enqueued_jobs { job.perform_later(project_name, mr_iid, action) }

      expect(Gitlab::MergeRequest::Commenter).to have_received(:call).with(
        project_name,
        mr_iid,
        ":x: `dependabot` tried to update merge request but failed.\n\n```\nError\n```"
      )
    end
  end
end
