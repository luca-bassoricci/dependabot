# frozen_string_literal: true

describe Gitlab::MergeRequest::Commenter, epic: :services, feature: :gitlab do
  let(:gitlab) { instance_double("Gitlab::Client", create_merge_request_note: nil) }
  let(:project) { "test" }
  let(:iid) { 1 }
  let(:comment) { "This is a comment!" }

  before do
    allow(Gitlab::Client).to receive(:new) { gitlab }
  end

  it "adds note to merge request" do
    described_class.call(project, iid, comment)

    expect(gitlab).to have_received(:create_merge_request_note).with(project, iid, comment)
  end
end
