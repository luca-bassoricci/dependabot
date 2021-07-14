# frozen_string_literal: true

describe Dependabot::Credentials, type: :config, epic: :services, feature: :credentials do
  subject(:credentials) { described_class.new.credentials }

  include_context "with config helper"

  let(:gitlab_token) { "test_token" }
  let(:github_token) { nil }

  let(:env) do
    {
      "SETTINGS__GITLAB_ACCESS_TOKEN" => gitlab_token,
      "SETTINGS__GITHUB_ACCESS_TOKEN" => github_token
    }
  end

  let(:gitlab_creds) do
    {
      "type" => "git_source",
      "host" => URI(AppConfig.gitlab_url).host,
      "username" => "x-access-token",
      "password" => gitlab_token
    }
  end

  let(:github_creds) do
    {
      "type" => "git_source",
      "host" => "github.com",
      "username" => "x-access-token",
      "password" => github_token
    }
  end

  around do |example|
    with_env(env) { example.run }
  end

  context "with gitlab credentials" do
    it "contains gitlab credentials" do
      expect(credentials).to eq([gitlab_creds])
    end
  end

  context "with github credentials" do
    let(:github_token) { "token" }

    it "contains github credentials" do
      expect(credentials).to eq([github_creds, gitlab_creds])
    end
  end
end
