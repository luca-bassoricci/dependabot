# frozen_string_literal: true

describe Gitlab::ConfigFetcher do
  subject(:config_fetcher) { described_class.call(repo, branch) }

  include_context "dependabot"

  let(:gitlab) { instance_double("Gitlab::client") }
  let(:branch) { "master" }

  before do
    allow(Gitlab).to receive(:client) { gitlab }
    allow(gitlab).to receive(:file_contents).with(repo, ".gitlab/dependabot.yml", branch) { raw_config }
  end

  it { is_expected.to eq(raw_config) }
end
