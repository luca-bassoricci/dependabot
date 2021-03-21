# frozen_string_literal: true

describe Gitlab::ConfigChecker, epic: :services, feature: :gitlab do
  subject { described_class.call(project_name, branch) }

  let(:gitlab) { instance_double("Gitlab::client") }
  let(:project_name) { "project" }
  let(:branch) { "master" }
  let(:file) { { file: "dependabot" } }

  before do
    allow(Gitlab).to receive(:client) { gitlab }
    allow(gitlab).to receive(:get_file).with(project_name, AppConfig.config_filename, branch) { file }
  end

  it { is_expected.to eq(true) }
end
