# frozen_string_literal: true

describe MergeRequestRecreationJob, epic: :jobs do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  let(:project_name) { "project" }
  let(:mr_iid) { 1 }
  let(:discussion_id) { "discussion-id" }

  before do
    allow(Dependabot::MergeRequestRecreator).to receive(:call)
    allow(Gitlab::MergeRequest::DiscussionReplier).to receive(:call)
  end

  context "with successful trigger" do
    it "performs enqued job" do
      perform_enqueued_jobs { job.perform_later(project_name, mr_iid, discussion_id) }

      expect(Dependabot::MergeRequestRecreator).to have_received(:call).with(project_name, mr_iid)
    end

    it "notifies recreate in progress" do
      perform_enqueued_jobs { job.perform_later(project_name, mr_iid, discussion_id) }

      expect(Gitlab::MergeRequest::DiscussionReplier).to have_received(:call).with(
        project_name: project_name,
        mr_iid: mr_iid,
        discussion_id: discussion_id,
        note: ":warning: `dependabot` is recreating merge request. All changes will be overwritten! :warning:"
      )
    end

    it "notifies recreate finished" do
      perform_enqueued_jobs { job.perform_later(project_name, mr_iid, discussion_id) }

      expect(Gitlab::MergeRequest::DiscussionReplier).to have_received(:call).with(
        project_name: project_name,
        mr_iid: mr_iid,
        discussion_id: discussion_id,
        note: ":white_check_mark: `dependabot` successfuly recreated merge request!"
      )
    end
  end

  context "with unsuccessful trigger" do
    it "notifies recreate failed" do
      allow(Dependabot::MergeRequestRecreator).to receive(:call).and_raise("error message")

      perform_enqueued_jobs { job.perform_later(project_name, mr_iid, discussion_id) }

      expect(Gitlab::MergeRequest::DiscussionReplier).to have_received(:call).with(
        project_name: project_name,
        mr_iid: mr_iid,
        discussion_id: discussion_id,
        note: ":x: `dependabot` failed recreating merge request.\n`error message`"
      )
    end
  end
end
