# frozen_string_literal: true

describe Gitlab::Hooks::Creator do
  include_context "dependabot"
  include_context "settings"

  let(:id) { 1 }
  let(:gitlab) { instance_double("Gitlab::Client") }
  let(:project) { Project.new(name: repo) }
  let(:branch) { "master" }
  let(:dependabot_url) { "https://test.com" }
  let(:hook_url) { "#{dependabot_url}/api/hooks" }
  let(:hook_args) do
    {
      merge_requests_events: true,
      push_events_branch_filter: branch,
      enable_ssl_verification: true
    }
  end

  before do
    allow(Gitlab).to receive(:client) { gitlab }
    allow(gitlab).to receive(:add_project_hook) { OpenStruct.new(id: id) }
  end

  around do |example|
    with_settings(SETTINGS__DEPENDABOT_URL: dependabot_url) { example.run }
  end

  it "creates webhook" do
    aggregate_failures do
      expect(described_class.call(project, branch)).to eq(id)
      expect(gitlab).to have_received(:add_project_hook).with(repo, hook_url, hook_args)
    end
  end
end
