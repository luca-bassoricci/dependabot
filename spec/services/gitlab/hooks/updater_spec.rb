# frozen_string_literal: true

describe Gitlab::Hooks::Updater do
  include_context "with dependabot helper"

  let(:id) { 1 }
  let(:branch) { "master" }
  let(:token) { "token" }
  let(:gitlab) { instance_double("Gitlab::Client") }
  let(:project) { Project.new(name: repo, webhook_id: id) }
  let(:dependabot_url) { "http://test.com" }
  let(:hook_url) { "#{AppConfig.dependabot_url}/api/hooks" }
  let(:hook_args) do
    {
      merge_requests_events: true,
      push_events_branch_filter: branch,
      enable_ssl_verification: true
    }
  end

  before do
    allow(CredentialsConfig).to receive(:gitlab_auth_token) { token }
    allow(Gitlab).to receive(:client) { gitlab }
    allow(gitlab).to receive(:edit_project_hook) { OpenStruct.new(id: id) }
    allow(gitlab).to receive(:project_hook).with(project.name, id) { hook_args }
  end

  it "updates existing webhook" do
    expect(described_class.call(project, branch)).to eq(id)
    expect(gitlab).to have_received(:edit_project_hook).with(
      project.name,
      id,
      hook_url,
      merge_requests_events: true,
      push_events_branch_filter: branch,
      enable_ssl_verification: true,
      token: token
    )
  end
end
