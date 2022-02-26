# frozen_string_literal: true

describe Config, :integration, epic: :models do
  subject(:config) { described_class.new(dependabot_config) }

  include_context "with dependabot helper"

  let(:password) { "password" }
  let(:expected_registries) { dependabot_config.first[:registries].first }
  let(:actual_registries) { config.mongoize.first[:registries].first }

  context "with credentials" do
    it "encrypts registries credentials for storage" do
      pass = EncryptHelper.decrypt(actual_registries["password"])

      expect(pass).to eq(password)
    end

    it "decrypts credentials for use" do
      expect(described_class.demongoize(config.mongoize)).to eq(config)
    end

    it "sanitizes auth fields in registries" do
      expect(config.sanitize.first[:registries]).to eq([expected_registries.except("password")])
    end
  end

  context "with persisted credentials" do
    let(:project) { Project.new(name: repo, config: dependabot_config) }

    before do
      project.save!
    end

    it "correctly fetches config" do
      expect(Project.find_by(name: repo).config.entry(package_ecosystem: "bundler")).to eq(dependabot_config.first)
    end
  end
end
