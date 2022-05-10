# frozen_string_literal: true

describe Gitlab::Hooks::Creator, epic: :services, feature: :gitlab do
  let(:gitlab) { instance_double("Gitlab::Client") }
  let(:project_name) { "project_name" }
  let(:branch) { "master" }
  let(:dependabot_url) { "https://test.com" }
  let(:hook_url) { "#{AppConfig.dependabot_url}/api/hooks" }
  let(:id) { 1 }

  let(:hook_args) do
    {
      merge_requests_events: true,
      note_events: true,
      pipeline_events: true,
      issues_events: true,
      push_events_branch_filter: branch,
      enable_ssl_verification: true
    }
  end

  before do
    allow(Gitlab).to receive(:client) { gitlab }
    allow(gitlab).to receive(:add_project_hook) { Gitlab::ObjectifiedHash.new(id: id) }
  end

  it "creates webhook" do
    aggregate_failures do
      expect(described_class.call(project_name, branch)).to eq(id)
      expect(gitlab).to have_received(:add_project_hook).with(project_name, hook_url, hook_args)
    end
  end
end
