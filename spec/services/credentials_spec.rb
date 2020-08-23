# frozen_string_literal: true

describe Credentials do
  let(:gitlab_creds) do
    {
      "type" => "git_source",
      "host" => URI(Settings.gitlab_url).host,
      "username" => "x-access-token",
      "password" => Settings.gitlab_access_token
    }
  end

  let(:github_creds) do
    {
      "type" => "git_source",
      "host" => "github.com",
      "username" => "x-access-token",
      "password" => Settings.github_access_token
    }
  end

  subject { described_class.fetch }

  before do
    described_class.instance_variable_set(:@credentials, nil)
    Settings.add_source!({ github_access_token: github_token })
    Settings.reload!
  end

  context "Credentials returns" do
    let(:github_token) { nil }

    it "only gitlab creds" do
      expect(subject).to eq([gitlab_creds])
    end
  end

  context "Credentials returns" do
    let(:github_token) { "token" }

    it "gitlab and githubs creds" do
      expect(subject).to eq([github_creds, gitlab_creds])
    end
  end
end
