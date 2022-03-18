# frozen_string_literal: true

describe Configuration, :integration, epic: :models do
  subject(:config) { described_class.new(updates: updates_config, registries: registries) }

  include_context "with dependabot helper"

  let(:project) { Project.find_by(name: repo) }
  let(:password) { "password" }

  before do
    Project.create!(name: repo, configuration: config)
  end

  describe "#updates" do
    it "returns persisted config" do
      expect(project.configuration.entry(package_ecosystem: "bundler")).to eq(updates_config.first)
    end
  end

  describe "#registries" do
    it "returns persisted credentials" do
      expect(project.configuration.registries.to_h).to eq(registries)
    end
  end
end
