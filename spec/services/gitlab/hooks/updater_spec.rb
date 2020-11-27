# frozen_string_literal: true

describe Gitlab::Hooks::Updater do
  include_context "dependabot"
  include_context "settings"

  let(:id) { 1 }
  let(:branch) { "master" }
  let(:token) { "token" }
  let(:gitlab) { instance_double("Gitlab::Client") }
  let(:project) { Project.new(name: repo, webhook_id: id) }
  let(:dependabot_url) { "http://test.com" }
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
    allow(gitlab).to receive(:edit_project_hook) { OpenStruct.new(id: id) }
    allow(gitlab).to receive(:project_hook).with(project.name, id) { hook_args }
  end

  around do |example|
    with_settings(SETTINGS__DEPENDABOT_URL: dependabot_url, SETTINGS__GITLAB_AUTH_TOKEN: token) { example.run }
  end

  it "updates existing webhook" do
    expect(described_class.call(project, branch)).to eq(id)
    expect(gitlab).to have_received(:edit_project_hook).with(
      project.name,
      id,
      hook_url,
      merge_requests_events: true,
      push_events_branch_filter: branch,
      enable_ssl_verification: false,
      token: token
    )
  end
end
