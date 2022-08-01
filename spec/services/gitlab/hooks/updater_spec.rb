# frozen_string_literal: true

describe Gitlab::Hooks::Updater, epic: :services, feature: :gitlab do
  let(:gitlab) { instance_double("Gitlab::Client", edit_project_hook: Gitlab::ObjectifiedHash.new(id: id)) }
  let(:project_name) { "project name" }
  let(:branch) { "master" }
  let(:token) { "token" }
  let(:dependabot_url) { "http://test.com" }
  let(:hook_url) { "#{AppConfig.dependabot_url}/api/hooks" }
  let(:id) { 1 }

  before do
    allow(CredentialsConfig).to receive(:gitlab_auth_token) { token }
    allow(Gitlab::ClientWithRetry).to receive(:current) { gitlab }
  end

  it "updates existing webhook" do
    expect(described_class.call(project_name, branch, id)).to eq(id)
    expect(gitlab).to have_received(:edit_project_hook).with(
      project_name,
      id,
      hook_url,
      merge_requests_events: true,
      note_events: true,
      pipeline_events: true,
      issues_events: true,
      push_events_branch_filter: branch,
      enable_ssl_verification: true,
      token: token
    )
  end
end
