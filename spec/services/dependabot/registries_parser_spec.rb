# frozen_string_literal: true

describe Dependabot::RegistriesParser, epic: :services, feature: :dependabot do
  subject(:parsed_registries) { described_class.call(registries: registries) }

  context "with correctly configured registries" do
    let(:registries) do
      [
        {
          type: "docker-registry",
          url: "https://registry.hub.docker.com",
          username: "octocat",
          password: "password"
        },
        {
          type: "npm-registry",
          url: "https://npm.pkg.github.com",
          token: "${{NPM_TEST_TOKEN}}"
        }
      ]
    end

    before do
      ENV["NPM_TEST_TOKEN"] = "test_token"
    end

    it "returns parsed registries" do
      expect(parsed_registries).to eq(
        [
          {
            "type" => "docker_registry",
            "registry" => "https://registry.hub.docker.com",
            "username" => "octocat",
            "password" => "password"
          },
          {
            "type" => "npm_registry",
            "registry" => "https://npm.pkg.github.com",
            "token" => "test_token"
          }
        ]
      )
    end
  end

  context "with partially configured credentials" do
    let(:registries) do
      [
        {
          type: "maven-repository",
          url: "https://maven-repo.com"
        },
        {
          type: "npm-registry",
          url: "https://npm.pkg.github.com",
          username: "test"
        }
      ]
    end

    it "filters out incorrect partial credentials" do
      expect(parsed_registries).to eq(
        [
          {
            "type" => "maven_repository",
            "url" => "https://maven-repo.com"
          }
        ]
      )
    end
  end
end
