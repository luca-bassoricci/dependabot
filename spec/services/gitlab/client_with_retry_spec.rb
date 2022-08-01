# frozen_string_literal: true

describe Gitlab::ClientWithRetry, epic: :services, feature: :gitlab do
  subject(:client) { described_class }

  include_context "with dependabot helper"

  let(:gitlab) { "gitlab_client" }
  let(:store) { {} }

  before do
    allow(RequestStore).to receive(:store) { store }
    allow(Dependabot::Clients::GitlabWithRetries).to receive(:new) { gitlab }
  end

  context "with default client" do
    it "fetches current gitlab client" do
      expect(client.current).to eq(gitlab)
    end
  end

  context "with stored gitlab client" do
    let(:token) { "test-token" }

    before do
      client.client_access_token = token
    end

    it "fetches stored client" do
      expect(client.current).to eq(gitlab)
      expect(Dependabot::Clients::GitlabWithRetries).to have_received(:new).with(
        endpoint: "#{AppConfig.gitlab_url}/api/v4",
        private_token: token
      )
    end
  end
end
