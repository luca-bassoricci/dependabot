# frozen_string_literal: true

describe Webhooks::CommentEventHandler, epic: :services, feature: :webhooks do
  include ActiveJob::TestHelper

  subject(:action) do
    described_class.call(
      discussion_id: discussion_id,
      note: command,
      project_name: project,
      mr_iid: mr_iid
    )
  end

  let(:gitlab) { instance_double("Gitlab::Client", rebase_merge_request: nil) }

  let(:discussion_id) { "11r4" }
  let(:project) { "dependabot/test" }
  let(:mr_iid) { 1 }

  let(:job) { MergeRequestRecreationJob }

  before do
    allow(Gitlab::Client).to receive(:new) { gitlab }
    allow(Gitlab::MergeRequest::DiscussionReplier).to receive(:call)
  end

  context "with invalid command" do
    let(:command) { "$dependabot test" }

    it "skips action" do
      aggregate_failures do
        expect(action).to be_nil
      end
    end
  end

  context "with rebase action" do
    let(:command) { "$dependabot rebase" }

    it "triggers merge request rebase" do
      aggregate_failures do
        expect(action).to eq({ rebase_in_progress: true })
        expect(gitlab).to have_received(:rebase_merge_request).with(project, mr_iid)
      end
    end

    it "notifies trigger successful" do
      action

      expect(Gitlab::MergeRequest::DiscussionReplier).to have_received(:call).with(
        project_name: project,
        mr_iid: mr_iid,
        discussion_id: discussion_id,
        note: ":white_check_mark: `dependabot` successfully triggered merge request rebase!"
      )
    end

    it "notifies trigger unsuccessful" do
      allow(gitlab).to receive(:rebase_merge_request).and_raise("error message")

      aggregate_failures do
        expect(action).to eq({ rebase_in_progress: false })
        expect(Gitlab::MergeRequest::DiscussionReplier).to have_received(:call).with(
          project_name: project,
          mr_iid: mr_iid,
          discussion_id: discussion_id,
          note: ":x: `dependabot` failed to trigger merge request rebase! `error message`"
        )
      end
    end
  end

  context "with recreate action" do
    let(:command) { "$dependabot recreate" }

    it "recreates merge request" do
      ActiveJob::Base.queue_adapter = :test

      expect { action }.to have_enqueued_job(job)
        .with(project, mr_iid, discussion_id)
        .on_queue("hooks")
    end
  end
end
