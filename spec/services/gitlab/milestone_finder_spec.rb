# frozen_string_literal: true

describe Gitlab::MilestoneFinder, epic: :services, feature: :gitlab do
  subject(:milestone_finder_return) { described_class.call(project_name, title) }

  let(:gitlab) { instance_double("Gitlab::Client", milestones: milestones) }
  let(:project_name) { "test-project" }
  let(:milestone) { Gitlab::ObjectifiedHash.new(id: 1) }

  before do
    allow(Gitlab::Client).to receive(:new) { gitlab }
  end

  context "with existing user" do
    let(:title) { "0.0.1" }
    let(:milestones) { [milestone] }

    it "returns array with ids", :aggregate_failures do
      expect(milestone_finder_return).to eq(1)
      expect(gitlab).to have_received(:milestones).with(project_name, title: title)
    end
  end

  context "with non existing user" do
    let(:title) { "0.0.2" }
    let(:milestones) { [] }

    it "returns nil", :aggregate_failures do
      expect(milestone_finder_return).to be_nil
      expect(gitlab).to have_received(:milestones).with(project_name, title: title)
    end
  end
end
