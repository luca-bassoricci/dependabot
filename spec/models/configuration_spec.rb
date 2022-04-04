# frozen_string_literal: true

describe Configuration, :integration, epic: :models do
  subject(:config) { described_class.new(updates: updates_config, registries: registries) }

  include_context "with dependabot helper"

  let(:project) { Project.find_by(name: repo) }
  let(:password) { "password" }

  before do
    Project.create!(name: repo, configuration: config)
  end

  describe "#updates" do
    it "returns persisted config" do
      expect(project.configuration.entry(package_ecosystem: "bundler")).to eq(updates_config.first)
    end
  end

  describe "#registries" do
    context "without value from environment variable" do
      it "returns registries credentials" do
        expect(project.configuration.registries.values).to eq(registries.values)
      end
    end

    context "with value from environment variable" do
      let(:password) { "docker-password" }

      let(:registries) do
        {
          "dockerhub" => {
            "type" => "docker_registry",
            "registry" => "registry.hub.docker.com",
            "username" => "octocat",
            "password" => "${{DOCKERHUB_PASSWORD}}"
          }
        }
      end

      around do |example|
        with_env("DOCKERHUB_PASSWORD" => password) { example.run }
      end

      it "returns registries credentials with correct password" do
        expect(project.configuration.registries.values).to eq([{
          "type" => "docker_registry",
          "registry" => "registry.hub.docker.com",
          "username" => "octocat",
          "password" => password
        }])
      end
    end
  end
end
