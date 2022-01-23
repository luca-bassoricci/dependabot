# frozen_string_literal: true

describe MergeRequestUpdateJob, epic: :jobs, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  let(:project_name) { "project" }
  let(:mr_iid) { 1 }

  let(:comment) do
    Gitlab::ObjectifiedHash.new(id: 1)
  end

  before do
    allow(Gitlab::MergeRequest::Commenter).to receive(:call) { comment }
    allow(Dependabot::MergeRequest::UpdateService).to receive(:call)
  end

  context "with successfull update" do
    it "performs enqued job" do
      perform_enqueued_jobs { job.perform_later(project_name, mr_iid) }

      expect(Gitlab::MergeRequest::Commenter).to have_received(:call).with(
        project_name,
        mr_iid,
        "`dependabot` is updating merge request!"
      )
      expect(Dependabot::MergeRequest::UpdateService).to have_received(:call).with(
        project_name: project_name,
        mr_iid: mr_iid,
        recreate: false
      )
    end
  end

  context "with failed update" do
    before do
      allow(Dependabot::MergeRequest::UpdateService).to receive(:call).and_raise("Error")
      allow(Gitlab::MergeRequest::DiscussionReplier).to receive(:call)
    end

    it "adds a comment on failed mr update" do
      perform_enqueued_jobs { job.perform_later(project_name, mr_iid) }

      expect(Gitlab::MergeRequest::DiscussionReplier).to have_received(:call).with(
        project_name: project_name,
        mr_iid: mr_iid,
        discussion_id: comment.id,
        note: ":x: Dependabot failed to update mr.\n\n```\nError\n```"
      )
    end
  end
end
