# frozen_string_literal: true

describe Gitlab::ConfigFetcher do
  subject(:config_fetcher_return) { described_class.call(repo, branch) }

  include_context "with dependabot helper"

  let(:gitlab) { instance_double("Gitlab::client") }
  let(:branch) { "master" }

  before do
    allow(Gitlab).to receive(:client) { gitlab }
    allow(gitlab).to receive(:file_contents).with(repo, ".gitlab/dependabot.yml", branch) { raw_config }
  end

  it "returns dependabot.yml contents" do
    expect(config_fetcher_return).to eq(raw_config)
  end
end
