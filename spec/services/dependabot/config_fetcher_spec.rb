# frozen_string_literal: true

describe Dependabot::ConfigFetcher, epic: :services, feature: :configuration do
  include_context "with dependabot helper"

  let(:project) { "project" }
  let(:default_branch) { "main" }

  before do
    allow(Gitlab::DefaultBranch).to receive(:call).with(kind_of(String)) { default_branch }
    allow(Gitlab::Config::Fetcher).to receive(:call) { raw_config }
  end

  context "without custom branch configuration" do
    it "fetches config from default branch" do
      expect(described_class.call(project)).to eq(dependabot_config)
      expect(Gitlab::Config::Fetcher).to have_received(:call).with(project, default_branch, update_cache: false)
    end

    it "fetches single entry of config from default branch" do
      expect(described_class.call(project, find_by: { package_manager: "bundler" })).to eq(
        dependabot_config.find { |entry| entry[:package_manager] == "bundler" }
      )
    end
  end

  context "with custom branch configuration" do
    let(:branch) { "custom_branch" }

    before do
      allow(AppConfig).to receive(:config_branch) { branch }
    end

    it "fetches config from configured branch" do
      expect(described_class.call(project)).to eq(dependabot_config)
      expect(Gitlab::Config::Fetcher).to have_received(:call).with(project, branch, update_cache: false)
    end
  end
end
