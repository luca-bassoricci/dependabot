# frozen_string_literal: true

describe Gitlab::Hooks::Finder do
  include_context "with dependabot helper"

  let(:id) { Faker::Number.number(digits: 10) }
  let(:gitlab) { instance_double("Gitlab::Client") }
  let(:hook_url) { "#{AppConfig.dependabot_url}/api/hooks" }

  before do
    allow(Gitlab).to receive(:client) { gitlab }
    allow(gitlab).to receive(:project_hooks) do
      OpenStruct.new(auto_paginate: [OpenStruct.new(id: id, url: hook_url)])
    end
  end

  it "returns hook id" do
    aggregate_failures do
      expect(described_class.call(repo)).to eq(id)
    end
  end
end
