# frozen_string_literal: true

describe Gitlab::ConfigFetcher do
  include_context "dependabot"

  let(:gitlab) { double("Gitlab") }
  let(:project) { OpenStruct.new(default_branch: "master") }

  subject { described_class.call(repo) }

  before do
    allow(Gitlab).to receive(:client) { gitlab }
    allow(gitlab).to receive(:project).with(repo) { project }
    allow(gitlab).to receive(:file_contents).with(repo, ".gitlab/dependabot.yml", "master") { raw_config }
  end

  context "fetches config file" do
    it "and returns contents" do
      expect(subject).to eq(raw_config)
    end
  end

  context "handles error" do
    it "when fetching default branch" do
      allow(gitlab).to receive(:project).with(repo) { nil }

      expect { subject }.to raise_error("Failed to fetch default branch for #{repo}")
    end

    it "when fetching configuration file" do
      allow(gitlab).to receive(:file_contents).with(repo, ".gitlab/dependabot.yml", "master") { nil }

      expect { subject }.to raise_error("Failed to fetch configuration for #{repo}")
    end
  end
end
