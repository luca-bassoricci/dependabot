# frozen_string_literal: true

describe Configuration, :integration, epic: :models do
  let!(:project) { create(:project, config_yaml: config_yaml) }

  let(:persisted_project) { Project.find_by(name: project.name) }

  let(:docker_password) { "docker-password" }
  let(:docker_parsed_password) { docker_password }

  let(:python_username) { "username" }
  let(:python_password) { "password" }
  let(:python_parsed_username) { python_username }
  let(:python_parsed_password) { python_password }

  let(:config_yaml) do
    <<~YAML
      version: 2
      registries:
        dockerhub:
          type: docker-registry
          url: registry.hub.docker.com
          username: octocat
          password: #{docker_password}
        python:
          type: python-index
          url: https://python-index.com
          username: #{python_username}
          password: #{python_password}
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
        "password" => docker_parsed_password
      },
      {
        "type" => "python_index",
        "token" => "#{python_parsed_username}:#{python_parsed_password}",
        "replaces-base" => false,
        "index-url" => "https://python-index.com"
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
      let(:docker_password) { "${{DOCKERHUB_PASSWORD}}" }
      let(:docker_parsed_password) { "docker-password" }

      let(:python_username) { "${{USERNAME}}" }
      let(:python_password) { "${{PASSWORD}}" }
      let(:python_parsed_username) { "username" }
      let(:python_parsed_password) { "password" }

      let(:env) do
        {
          "DOCKERHUB_PASSWORD" => docker_parsed_password,
          "USERNAME" => python_parsed_username,
          "PASSWORD" => python_parsed_password
        }
      end

      around do |example|
        with_env(env) { example.run }
      end

      it "returns registries credentials with correct password" do
        expect(persisted_project.configuration.registries.select(".*")).to eq(registries)
      end
    end
  end
end
