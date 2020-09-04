# frozen_string_literal: true

describe Credentials do
  let(:github_token) { nil }
  let(:maven_repo_url) { nil }
  let(:maven_repo_user) { nil }
  let(:maven_repo_pass) { nil }

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

  let(:maven_repo_creds) do
    {
      "type" => "maven_repository",
      "url" => Settings.credentials_maven_repository_url,
      "username" => Settings.credentials_maven_repository_username,
      "password" => Settings.credentials_maven_repository_password
    }
  end

  subject { described_class.fetch }

  before do
    described_class.instance_variable_set(:@credentials, nil)
    Settings.add_source!(
      {
        github_access_token: github_token,
        credentials_maven_repository_url: maven_repo_url,
        credentials_maven_repository_username: maven_repo_user,
        credentials_maven_repository_password: maven_repo_pass
      }
    )
    Settings.reload!
  end

  context "Credentials returns" do
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

  context "Credentials returns" do
    let(:maven_repo_url) { "url" }
    let(:maven_repo_user) { "username" }
    let(:maven_repo_pass) { "password" }

    it "gitlab and maven creds" do
      expect(subject).to eq([gitlab_creds, maven_repo_creds])
    end
  end
end
