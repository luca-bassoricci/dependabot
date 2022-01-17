# frozen_string_literal: true

describe Gitlab::ConfigFile::Fetcher, epic: :services, feature: :gitlab do
  subject(:config_fetcher_return) { described_class.call(project_name, branch) }

  let(:gitlab) { instance_double("Gitlab::client") }
  let(:project_name) { "project" }
  let(:branch) { "master" }
  let(:raw_config) { "dependabot.yml contents" }

  before do
    allow(Gitlab).to receive(:client) { gitlab }
    allow(gitlab).to receive(:file_contents).with(project_name, DependabotConfig.config_filename, branch) { raw_config }
  end

  it "returns dependabot.yml contents" do
    expect(config_fetcher_return).to eq(raw_config)
  end
end
