# frozen_string_literal: true

describe Credentials do
  let(:github_token) { nil }
  let(:maven_url) { nil }
  let(:maven_username) { nil }
  let(:maven_password) { nil }

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

  let(:maven_creds) do
    {
      "type" => "maven_repository",
      "url" => Settings.credentials.maven.repository.url,
      "username" => Settings.credentials.maven.repository.username,
      "password" => Settings.credentials.maven.repository.password
    }
  end

  subject { described_class.fetch }

  before do
    described_class.instance_variable_set(:@credentials, nil)
    Settings.add_source!(
      {
        github_access_token: github_token,
        credentials: {
          maven: {
            repository: {
              url: maven_url,
              username: maven_username,
              password: maven_password
            }
          }
        }
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
    let(:maven_url) { "url" }
    let(:maven_username) { "username" }
    let(:maven_password) { "password" }

    it "gitlab and maven creds" do
      expect(subject).to eq([gitlab_creds, maven_creds])
    end
  end
end
