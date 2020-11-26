# frozen_string_literal: true

describe Gitlab::Hooks::Updater do
  include_context "dependabot"
  include_context "settings"

  let(:id) { 1 }
  let(:gitlab) { instance_double("Gitlab::Client") }
  let(:project) { Project.new(name: repo, webhook_id: id) }
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
    allow(gitlab).to receive(:edit_project_hook) { OpenStruct.new(id: id) }
    allow(gitlab).to receive(:project_hook).with(project.name, id) { hook_args }
  end

  around do |example|
    with_settings(SETTINGS__DEPENDABOT_URL: dependabot_url) { example.run }
  end

  context "with changes" do
    let(:dependabot_url) { "http://test.com" }

    it "updates existing webhook" do
      expect(described_class.call(project, branch)).to eq(id)
      expect(gitlab).to have_received(:edit_project_hook).with(
        project.name,
        id,
        hook_url,
        merge_requests_events: true,
        push_events_branch_filter: branch,
        enable_ssl_verification: false
      )
    end
  end

  context "without changes" do
    it "skips update" do
      expect(described_class.call(project, branch)).to eq(id)
      expect(gitlab).not_to have_received(:edit_project_hook)
    end
  end
end
