# frozen_string_literal: true

describe Gitlab::ConfigFetcher do
  subject(:config_fetcher) { described_class.call(repo) }

  include_context "dependabot"

  let(:gitlab) { instance_double("Gitlab::client") }
  let(:project) { OpenStruct.new(default_branch: "master") }

  before do
    allow(Gitlab).to receive(:client) { gitlab }
    allow(gitlab).to receive(:project).with(repo) { project }
    allow(gitlab).to receive(:file_contents).with(repo, ".gitlab/dependabot.yml", "master") { raw_config }
  end

  context "when fetching config file" do
    it { is_expected.to eq(raw_config) }
  end

  context "when encountering error" do
    context "when fetching default branch" do
      before { allow(gitlab).to receive(:project).with(repo).and_return(nil) }

      it { expect { config_fetcher }.to raise_error("Failed to fetch default branch for #{repo}") }
    end

    context "when fetching configuration file" do
      before do
        allow(gitlab).to receive(:file_contents).with(repo, ".gitlab/dependabot.yml", "master").and_return(nil)
      end

      it { expect { config_fetcher }.to raise_error("Failed to fetch configuration for #{repo}") }
    end
  end
end
