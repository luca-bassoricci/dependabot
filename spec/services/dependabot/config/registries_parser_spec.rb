# frozen_string_literal: true

describe Dependabot::Config::RegistriesParser, epic: :services, feature: :dependabot do
  subject(:parsed_registries) { described_class.call(registries: registries) }

  context "with correctly configured registries" do
    let(:registries) do
      {
        dockerhub:
        {
          type: "docker-registry",
          url: "https://registry.hub.docker.com",
          username: "octocat",
          password: "password"
        },
        npm: {
          type: "npm-registry",
          url: "https://npm.pkg.github.com",
          token: "${{NPM_TEST_TOKEN}}"
        }
      }
    end

    before do
      ENV["NPM_TEST_TOKEN"] = "test_token"
    end

    it "returns parsed registries" do
      expect(parsed_registries).to eq(
        {
          "dockerhub" => {
            "type" => "docker_registry",
            "registry" => "registry.hub.docker.com",
            "username" => "octocat",
            "password" => "password"
          },
          "npm" => {
            "type" => "npm_registry",
            "registry" => "npm.pkg.github.com",
            "token" => "test_token"
          }
        }
      )
    end
  end

  context "with partially configured credentials" do
    let(:registries) do
      {
        maven: {
          type: "maven-repository",
          url: "https://maven-repo.com"
        },
        npm: {
          type: "npm-registry",
          url: "https://npm.pkg.github.com",
          username: "test"
        }
      }
    end

    it "filters out incorrect partial credentials" do
      expect(parsed_registries).to eq(
        {
          "maven" => {
            "type" => "maven_repository",
            "url" => "https://maven-repo.com"
          }
        }
      )
    end
  end
end
