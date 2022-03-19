# frozen_string_literal: true

describe Gitlab::BranchRemover, epic: :services, feature: :gitlab do
  let(:gitlab) { instance_double("Gitlab::Client", delete_branch: "", branch: "") }
  let(:project_name) { "project-name" }
  let(:branch) { "branch-name" }

  before do
    allow(Gitlab::Client).to receive(:new) { gitlab }
  end

  context "when branch exists" do
    it "deletes branch" do
      described_class.call(project_name, branch)

      expect(gitlab).to have_received(:delete_branch).with(project_name, branch)
    end
  end

  context "when branch doesn't exist" do
    let(:error_response) do
      Gitlab::Error::NotFound.new(
        Gitlab::ObjectifiedHash.new(
          code: 404,
          parsed_response: "Not found",
          request: { base_uri: "gitlab.com", path: "/branch" }
        )
      )
    end

    before do
      allow(gitlab).to receive(:branch).and_raise(error_response)
    end

    it "skips branch deletion" do
      described_class.call(project_name, branch)

      expect(gitlab).not_to have_received(:delete_branch).with(project_name, branch)
    end
  end
end
