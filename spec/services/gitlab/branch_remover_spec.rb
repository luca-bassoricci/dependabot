# frozen_string_literal: true

describe Gitlab::BranchRemover, epic: :services, feature: :gitlab do
  let(:gitlab) { instance_double("Gitlab::Client", delete_branch: "") }
  let(:project_name) { "project-name" }
  let(:branch) { "branch-name" }

  before do
    allow(Gitlab::Client).to receive(:new) { gitlab }
  end

  it "deletes branch" do
    described_class.call(project_name, branch)

    expect(gitlab).to have_received(:delete_branch).with(project_name, branch)
  end
end
