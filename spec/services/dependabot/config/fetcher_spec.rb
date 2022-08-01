# frozen_string_literal: true

describe Dependabot::Config::Fetcher, epic: :services, feature: :configuration do
  subject(:fetched_config) { described_class.call(project) }

  include_context "with dependabot helper"

  let(:project) { "project" }
  let(:default_branch) { "main" }
  let(:config) { Configuration.new(updates: updates_config, registries: registries) }

  let(:gitlab) do
    instance_double("Gitlab::Client", project: Gitlab::ObjectifiedHash.new(default_branch: default_branch))
  end

  before do
    allow(Gitlab::ClientWithRetry).to receive(:current) { gitlab }
    allow(Gitlab::ConfigFile::Fetcher).to receive(:call) { raw_config }
  end

  context "without custom branch configuration" do
    it "fetches config from default branch" do
      expect(fetched_config).to eq(config)
      expect(Gitlab::ConfigFile::Fetcher).to have_received(:call).with(project, default_branch)
    end
  end

  context "with custom branch configuration" do
    let(:branch) { "custom_branch" }

    before do
      allow(DependabotConfig).to receive(:config_branch) { branch }
    end

    it "fetches config from configured branch" do
      expect(fetched_config).to eq(config)
      expect(Gitlab::ConfigFile::Fetcher).to have_received(:call).with(project, branch)
    end
  end
end
