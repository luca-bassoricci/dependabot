# frozen_string_literal: true

describe Gitlab::Hooks::Finder, epic: :services, feature: :gitlab do
  let(:gitlab) { instance_double("Gitlab::Client") }
  let(:project_name) { "project name" }
  let(:hook_url) { "#{AppConfig.dependabot_url}/api/hooks" }
  let(:id) { 1 }

  before do
    allow(Gitlab::ClientWithRetry).to receive(:current) { gitlab }
    allow(gitlab).to receive(:project_hooks).with(project_name).and_return(
      Gitlab::ObjectifiedHash.new(auto_paginate: [{ id: id, url: hook_url }])
    )
  end

  it "returns hook id" do
    aggregate_failures do
      expect(described_class.call(project_name)).to eq(id)
    end
  end
end
