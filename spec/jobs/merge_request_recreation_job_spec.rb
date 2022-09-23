# frozen_string_literal: true

describe MergeRequestRecreationJob, :integration, epic: :jobs, feature: "mr recreate", type: :job do
  include ActiveJob::TestHelper

  subject(:job) do
    described_class.perform_later(project_name: project_name, mr_iid: mr_iid, discussion_id: discussion_id)
  end

  let(:gitlab) { instance_double("Gitlab::Client", resolve_merge_request_discussion: nil) }
  let(:project_name) { "project" }
  let(:mr_iid) { 1 }
  let(:discussion_id) { "discussion-id" }
  let(:replier_args) do
    {
      project_name: project_name,
      mr_iid: mr_iid,
      discussion_id: discussion_id
    }
  end

  before do
    allow(Gitlab::MergeRequest::DiscussionReplier).to receive(:call)
    allow(Gitlab::ClientWithRetry).to receive(:current)
      .and_return(gitlab)
    allow(Dependabot::MergeRequest::UpdateService).to receive(:call)
      .and_return(Dependabot::MergeRequest::UpdateService::RECREATED)
  end

  context "with successful trigger" do
    it "performs enqued job" do
      perform_enqueued_jobs { job }

      expect(Dependabot::MergeRequest::UpdateService).to have_received(:call).with(
        project_name: project_name,
        mr_iid: mr_iid,
        action: Dependabot::MergeRequest::UpdateService::RECREATE
      )
    end

    it "notifies on recreate", :aggregate_failures do
      perform_enqueued_jobs { job }

      expect(Gitlab::MergeRequest::DiscussionReplier).to have_received(:call).with(
        **replier_args,
        note: ":warning: `dependabot` is recreating merge request. All changes will be overwritten! :warning:"
      )
      expect(Gitlab::MergeRequest::DiscussionReplier).to have_received(:call).with(
        **replier_args,
        note: ":white_check_mark: `dependabot` successfuly recreated merge request!"
      )
      expect(gitlab).to have_received(:resolve_merge_request_discussion).with(
        project_name,
        mr_iid,
        discussion_id,
        resolved: true
      )
    end
  end

  context "with unsuccessful trigger" do
    it "notifies recreate failed" do
      allow(Dependabot::MergeRequest::UpdateService).to receive(:call).and_raise("error message")

      perform_enqueued_jobs { job }

      expect(Gitlab::MergeRequest::DiscussionReplier).to have_received(:call).with(
        **replier_args,
        note: ":x: `dependabot` failed recreating merge request.\n\n```\nerror message\n```"
      )
      expect(gitlab).not_to have_received(:resolve_merge_request_discussion)
    end
  end
end
