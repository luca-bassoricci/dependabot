# frozen_string_literal: true

describe Gitlab::Hooks::Creator, epic: :services, feature: :gitlab do
  include_context "with dependabot helper"

  let(:id) { Faker::Number.number(digits: 10) }
  let(:gitlab) { instance_double("Gitlab::Client") }
  let(:branch) { "master" }
  let(:dependabot_url) { "https://test.com" }
  let(:hook_url) { "#{AppConfig.dependabot_url}/api/hooks" }
  let(:hook_args) do
    {
      merge_requests_events: true,
      note_events: true,
      push_events_branch_filter: branch,
      enable_ssl_verification: true
    }
  end

  before do
    allow(Gitlab).to receive(:client) { gitlab }
    allow(gitlab).to receive(:add_project_hook) { OpenStruct.new(id: id) }
  end

  it "creates webhook" do
    aggregate_failures do
      expect(described_class.call(repo, branch)).to eq(id)
      expect(gitlab).to have_received(:add_project_hook).with(repo, hook_url, hook_args)
    end
  end
end
