# frozen_string_literal: true

describe Gitlab::MergeRequest::Acceptor, epic: :services, feature: :gitlab do
  let(:gitlab) { instance_double("Gitlab::Client", accept_merge_request: nil) }
  let(:project_name) { "project_name" }
  let(:mr_iid) { 1 }
  let(:opts) { { merge_when_pipeline_succeeds: true } }

  before do
    allow(Gitlab::Client).to receive(:new) { gitlab }
  end

  it "accepts mr and set to merge" do
    described_class.call(project_name, mr_iid, opts)

    expect(gitlab).to have_received(:accept_merge_request).with(project_name, mr_iid, opts)
  end
end
