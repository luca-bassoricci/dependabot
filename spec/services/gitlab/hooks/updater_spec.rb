# frozen_string_literal: true

describe Gitlab::Hooks::Updater do
  include_context "with dependabot helper"

  let(:id) { Faker::Number.number(digits: 10) }
  let(:branch) { "master" }
  let(:token) { "token" }
  let(:gitlab) { instance_double("Gitlab::Client") }
  let(:dependabot_url) { "http://test.com" }
  let(:hook_url) { "#{AppConfig.dependabot_url}/api/hooks" }

  before do
    allow(CredentialsConfig).to receive(:gitlab_auth_token) { token }
    allow(Gitlab).to receive(:client) { gitlab }
    allow(gitlab).to receive(:edit_project_hook) { OpenStruct.new(id: id) }
  end

  it "updates existing webhook" do
    expect(described_class.call(repo, branch, id)).to eq(id)
    expect(gitlab).to have_received(:edit_project_hook).with(
      repo,
      id,
      hook_url,
      merge_requests_events: true,
      push_events_branch_filter: branch,
      enable_ssl_verification: true,
      token: token
    )
  end
end
