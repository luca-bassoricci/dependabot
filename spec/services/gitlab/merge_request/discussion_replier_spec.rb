# frozen_string_literal: true

describe Gitlab::MergeRequest::DiscussionReplier, epic: :services, feature: :gitlab do
  let(:gitlab) { instance_double("Gitlab::Client", create_merge_request_discussion_note: nil) }
  let(:project_name) { "test" }
  let(:mr_iid) { 1 }
  let(:discussion_id) { "112r" }
  let(:note) { "test" }

  before do
    allow(Gitlab::ClientWithRetry).to receive(:current) { gitlab }
  end

  it "adds reply to merge request note" do
    described_class.call(
      project_name: project_name,
      mr_iid: mr_iid,
      discussion_id: discussion_id,
      note: note
    )

    expect(gitlab).to have_received(:create_merge_request_discussion_note).with(
      project_name,
      mr_iid,
      discussion_id,
      body: note
    )
  end
end
