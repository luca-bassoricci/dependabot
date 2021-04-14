# frozen_string_literal: true

describe Dependabot::Credentials, type: :config, epic: :services, feature: :credentials do
  subject(:credentials) { described_class.new.credentials }

  include_context "with config helper"

  let(:gitlab_token) { "test_token" }
  let(:github_token) { nil }

  let(:maven_url) { nil }
  let(:maven_username) { nil }
  let(:maven_password) { nil }

  let(:docker_registry) { nil }
  let(:docker_username) { nil }
  let(:docker_password) { nil }

  let(:npm_registry) { nil }
  let(:npm_token) { nil }

  let(:env) do
    {
      "SETTINGS__GITLAB_ACCESS_TOKEN" => gitlab_token,
      "SETTINGS__GITHUB_ACCESS_TOKEN" => github_token,
      "SETTINGS__CREDENTIALS__MAVEN__REPO1__URL" => maven_url,
      "SETTINGS__CREDENTIALS__MAVEN__REPO1__USERNAME" => maven_username,
      "SETTINGS__CREDENTIALS__MAVEN__REPO1__PASSWORD" => maven_password,
      "SETTINGS__CREDENTIALS__DOCKER__REGISTRY1__REGISTRY" => docker_registry,
      "SETTINGS__CREDENTIALS__DOCKER__REGISTRY1__USERNAME" => docker_username,
      "SETTINGS__CREDENTIALS__DOCKER__REGISTRY1__PASSWORD" => docker_password,
      "SETTINGS__CREDENTIALS__NPM__REGISTRY1__REGISTRY" => npm_registry,
      "SETTINGS__CREDENTIALS__NPM__REGISTRY1__TOKEN" => npm_token
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

  let(:maven_creds) do
    {
      "type" => "maven_repository",
      "url" => maven_url,
      "username" => maven_username,
      "password" => maven_password
    }
  end

  let(:docker_creds) do
    {
      "type" => "docker_registry",
      "registry" => docker_registry,
      "username" => docker_username,
      "password" => docker_password
    }
  end

  let(:npm_creds) do
    {
      "type" => "npm_registry",
      "registry" => npm_registry,
      "token" => npm_token
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

  context "with maven credentials" do
    context "with fully configured credentials" do
      let(:maven_url) { "url" }
      let(:maven_username) { "username" }
      let(:maven_password) { "password" }

      it "contains maven repo credentials" do
        expect(credentials).to eq([gitlab_creds, maven_creds])
      end
    end

    context "with only url configured in credentials" do
      let(:maven_url) { "url" }

      it "contains maven repo credentials with just the configred url" do
        expect(credentials).to eq([gitlab_creds, maven_creds.reject { |_k, v| v.nil? }])
      end
    end

    context "with username missing in credentials" do
      let(:maven_url) { "url" }
      let(:maven_password) { "password" }

      it "does not contain maven repo credentials" do
        expect(credentials).to eq([gitlab_creds])
      end
    end
  end

  context "with docker credentials" do
    context "with fully configured credentials" do
      let(:docker_registry) { "dockerhub" }
      let(:docker_username) { "username" }
      let(:docker_password) { "password" }

      it "contains docker registry credentials" do
        expect(credentials).to eq([gitlab_creds, docker_creds])
      end
    end

    context "with partially configured credentials" do
      let(:docker_registry) { "dockerhub" }
      let(:docker_password) { "password" }

      it "does not contain docker registry credentials" do
        expect(credentials).to eq([gitlab_creds])
      end
    end
  end

  context "with npm credentials" do
    context "with fully configured credentials" do
      let(:npm_registry) { "npm-private" }
      let(:npm_token) { "username" }

      it "contains npm registry credentials" do
        expect(credentials).to eq([gitlab_creds, npm_creds])
      end
    end

    context "with partially configured credentials" do
      let(:npm_registry) { "npm-private" }

      it "does not contain npm registry credentials" do
        expect(credentials).to eq([gitlab_creds])
      end
    end
  end
end
