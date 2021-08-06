# frozen_string_literal: true

describe Dependabot::ConfigFetcher, epic: :services, feature: :configuration do
  include_context "with dependabot helper"

  let(:gitlab) { instance_double("Gitlab::client", project: OpenStruct.new(default_branch: default_branch)) }
  let(:project) { "project" }
  let(:default_branch) { "main" }

  before do
    allow(Gitlab).to receive(:client) { gitlab }
    allow(Gitlab::Config::Fetcher).to receive(:call) { raw_config }
  end

  context "without custom branch configuration" do
    it "fetches config from default branch" do
      expect(described_class.call(project)).to eq(dependabot_config)
      expect(Gitlab::Config::Fetcher).to have_received(:call).with(project, default_branch, update_cache: false)
    end

    it "fetches single entry of config from default branch" do
      expect(described_class.call(project, find_by: { package_ecosystem: "bundler" })).to eq(
        dependabot_config.find { |entry| entry[:package_ecosystem] == "bundler" }
      )
    end
  end

  context "with custom branch configuration" do
    let(:branch) { "custom_branch" }

    before do
      allow(DependabotConfig).to receive(:config_branch) { branch }
    end

    it "fetches config from configured branch" do
      expect(described_class.call(project)).to eq(dependabot_config)
      expect(Gitlab::Config::Fetcher).to have_received(:call).with(project, branch, update_cache: false)
    end
  end
end
