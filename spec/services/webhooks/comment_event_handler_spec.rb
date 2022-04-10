# frozen_string_literal: true

describe Webhooks::CommentEventHandler, :integration, epic: :services, feature: :webhooks do
  include ActiveJob::TestHelper

  subject(:action) do
    described_class.call(
      discussion_id: discussion_id,
      note: command,
      project_name: project.name,
      mr_iid: mr_iid
    )
  end

  let(:gitlab) { instance_double("Gitlab::Client", rebase_merge_request: nil, resolve_merge_request_discussion: nil) }
  let(:project) { build(:project_with_mr) }
  let(:mr_iid) { project.merge_requests.first.iid }
  let(:job) { MergeRequestRecreationJob }
  let(:discussion_id) { "11r4" }

  before do
    allow(Gitlab::Client).to receive(:new) { gitlab }
    allow(Gitlab::MergeRequest::DiscussionReplier).to receive(:call)
  end

  context "with invalid command", :aggregate_failures do
    let(:command) { "$dependabot test" }

    it "skips action" do
      expect(action).to be_nil
    end
  end

  context "with non existing merge request" do
    let(:command) { "$dependabot rebase" }

    it "skips action" do
      expect(action).to be_nil
    end
  end

  context "with rebase action", :aggregate_failures do
    let(:project) { create(:project_with_mr) }
    let(:command) { "$dependabot rebase" }

    it "triggers merge request rebase" do
      expect(action).to eq({ rebase_in_progress: true })
      expect(gitlab).to have_received(:rebase_merge_request).with(project.name, mr_iid)
    end

    it "notifies trigger successful" do
      action

      expect(Gitlab::MergeRequest::DiscussionReplier).to have_received(:call).with(
        project_name: project.name,
        mr_iid: mr_iid,
        discussion_id: discussion_id,
        note: ":white_check_mark: `dependabot` successfully triggered merge request rebase!"
      )
      expect(gitlab).to have_received(:resolve_merge_request_discussion).with(
        project.name,
        mr_iid,
        discussion_id,
        resolved: true
      )
    end

    it "notifies trigger unsuccessful" do
      allow(gitlab).to receive(:rebase_merge_request).and_raise("error message")

      expect(action).to eq({ rebase_in_progress: false })
      expect(Gitlab::MergeRequest::DiscussionReplier).to have_received(:call).with(
        project_name: project.name,
        mr_iid: mr_iid,
        discussion_id: discussion_id,
        note: ":x: `dependabot` failed to trigger merge request rebase! `error message`"
      )
      expect(gitlab).not_to have_received(:resolve_merge_request_discussion)
    end
  end

  context "with recreate action" do
    let(:project) { create(:project_with_mr) }
    let(:command) { "$dependabot recreate" }

    it "recreates merge request" do
      ActiveJob::Base.queue_adapter = :test

      expect { action }.to have_enqueued_job(job)
        .with(project.name, mr_iid, discussion_id)
        .on_queue("hooks")
    end
  end
end
