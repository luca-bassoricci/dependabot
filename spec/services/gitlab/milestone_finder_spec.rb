# frozen_string_literal: true

describe Gitlab::MilestoneFinder, epic: :services, feature: :gitlab do
  subject(:milestone_id) { described_class.call(project_name, title) }

  let(:gitlab) { instance_double("Gitlab::Client") }
  let(:project_name) { "test-project" }
  let(:milestone) { Gitlab::ObjectifiedHash.new(id: 1) }

  before do
    allow(Gitlab::ClientWithRetry).to receive(:current) { gitlab }
    allow(gitlab).to receive(:milestones)
      .with(project_name, title: title, include_parent_milestones: true)
      .and_return(milestones)
  end

  context "with existing milestone" do
    let(:title) { "0.0.1" }
    let(:milestones) { [milestone] }

    it "returns array with ids" do
      expect(milestone_id).to eq(1)
    end
  end

  context "with non existing milestone" do
    let(:title) { "0.0.2" }
    let(:milestones) { [] }

    it "returns nil" do
      expect(milestone_id).to be_nil
    end
  end
end
