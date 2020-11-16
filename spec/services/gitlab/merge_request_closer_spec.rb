# frozen_string_literal: true

describe Gitlab::MergeRequestCloser do
  let(:gitlab) { instance_double("Gitlab::Client", update_merge_request: nil) }
  let(:project) { "test" }
  let(:iid) { 1 }

  subject { described_class.call(project, iid) }

  before do
    allow(Gitlab::Client).to receive(:new) { gitlab }
  end

  it "closes merge request" do
    subject

    expect(gitlab).to have_received(:update_merge_request).with(project, iid, state_event: "close")
  end
end
