# frozen_string_literal: true

describe Configuration, :integration, epic: :models do
  let!(:project) { create(:project, config_yaml: config_yaml) }

  let(:persisted_project) { Project.find_by(name: project.name) }
  let(:password) { "docker-password" }
  let(:parsed_password) { password }

  let(:config_yaml) do
    <<~YAML
      version: 2
      registries:
        dockerhub:
          type: docker-registry
          url: registry.hub.docker.com
          username: octocat
          password: #{password}
      updates:
        - package-ecosystem: bundler
          directory: "/"
          schedule:
            interval: weekly
    YAML
  end

  let(:registries) do
    [
      {
        "type" => "docker_registry",
        "registry" => "registry.hub.docker.com",
        "username" => "octocat",
        "password" => parsed_password
      }
    ]
  end

  describe "#updates", feature: "updates config" do
    it "returns persisted config" do
      expect(
        persisted_project.configuration.entry(package_ecosystem: "bundler").slice(:package_ecosystem, :directory)
      ).to eq(
        package_ecosystem: "bundler",
        directory: "/"
      )
    end
  end

  describe "#registries", feature: "registries config" do
    context "without value from environment variable" do
      it "returns registries credentials" do
        expect(persisted_project.configuration.registries.select(".*")).to eq(registries)
      end
    end

    context "with value from environment variable" do
      let(:password) { "${{DOCKERHUB_PASSWORD}}" }
      let(:parsed_password) { "docker-password" }

      around do |example|
        with_env("DOCKERHUB_PASSWORD" => parsed_password) { example.run }
      end

      it "returns registries credentials with correct password" do
        expect(persisted_project.configuration.registries.select(".*")).to eq(registries)
      end
    end
  end
end
