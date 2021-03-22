# frozen_string_literal: true

describe Gitlab::MergeRequestRebaser, epic: :services, feature: :gitlab do
  let(:gitlab) { instance_double("Gitlab::Client", rebase_merge_request: nil) }
  let(:project) { "test" }
  let(:iid) { 1 }

  before do
    allow(Gitlab::Client).to receive(:new) { gitlab }
  end

  it "rebases merge request" do
    described_class.call(project, iid)

    expect(gitlab).to have_received(:rebase_merge_request).with(project, iid)
  end
end
