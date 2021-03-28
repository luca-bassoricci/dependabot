# frozen_string_literal: true

describe Gitlab::MergeRequest::Finder, epic: :services, feature: :gitlab do
  subject(:mr_finder_return) do
    described_class.call(project: repo, **search_params)
  end

  include_context "with dependabot helper"

  let(:gitlab) { instance_double("Gitlab::Client", merge_requests: [mr]) }
  let(:mr) { OpenStruct.new(iid: 1) }
  let(:search_params) do
    {
      source_branch: "source_branch",
      target_branch: "master",
      state: "opened"
    }
  end

  before do
    allow(Gitlab::Client).to receive(:new) { gitlab }
  end

  it "returns merge request" do
    expect(mr_finder_return).to eq(mr)
    expect(gitlab).to have_received(:merge_requests).with(
      repo,
      with_merge_status_recheck: true,
      **search_params
    )
  end
end
