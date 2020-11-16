# frozen_string_literal: true

describe Gitlab::MergeRequestAcceptor do
  let(:gitlab) { instance_double("Gitlab::Client", accept_merge_request: nil) }
  let(:mr) do
    OpenStruct.new(
      iid: 1,
      project_id: 1,
      references: OpenStruct.new(short: "test")
    )
  end

  subject { described_class.call(mr) }

  before do
    allow(Gitlab::Client).to receive(:new) { gitlab }
  end

  it "accepts mr and set to merge" do
    subject

    expect(gitlab).to have_received(:accept_merge_request).with(
      mr.project_id,
      mr.iid,
      merge_when_pipeline_succeeds: true
    )
  end
end
