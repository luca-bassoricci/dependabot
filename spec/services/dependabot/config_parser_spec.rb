# frozen_string_literal: true

describe Dependabot::ConfigParser, epic: :services, feature: :configuration do
  subject(:parser) { described_class }

  include_context "with dependabot helper"

  let(:allow_conf) { [{ dependency_type: "direct" }] }
  let(:ignore_conf) { [{ dependency_name: "rspec", versions: ["3.x", "4.x"] }] }

  context "with valid configuration and registries" do
    let(:config_yml) do
      <<~YAML
        version: 2
        registries:
          dockerhub:
            type: docker-registry
            url: https://registry.hub.docker.com
            username: octocat
            password: password
          npm:
            type: npm-registry
            url: https://npm.pkg.github.com
            token: test_token
        updates:
          - package-ecosystem: bundler
            directory: "/"
            schedule:
              interval: weekly
            registries:
              - npm
      YAML
    end

    it "returns parsed configuration" do
      expect(parser.call(File.read("spec/fixture/gitlab/responses/dependabot.yml"))).to eq(dependabot_config)
    end

    it "returns parsed configuration with explicitly allowed registries" do
      expect(parser.call(config_yml).first[:registries]).to eq(
        [{
          "type" => "npm_registry",
          "registry" => "https://npm.pkg.github.com",
          "token" => "test_token"
        }]
      )
    end

    it "sets reject_external_code: true by default" do
      expect(parser.call(config_yml).first[:reject_external_code]).to eq(true)
    end
  end

  context "with valid config and no registries" do
    let(:config_yml) do
      <<~YAML
        version: 2
        updates:
          - package-ecosystem: bundler
            directory: "/"
            schedule:
              interval: weekly
      YAML
    end

    it "sets reject_external_code: false by default" do
      expect(parser.call(config_yml).first[:reject_external_code]).to eq(false)
    end
  end

  context "with invalid config" do
    let(:config_yml) do
      <<~YAML
        version: 2
        updates:
          - package-ecosystem: bundler
            vendor: "true"
            schedule:
              time: "19:00"
            milestone: 4
            ignore:
              - versions: ["3.x", "4.x"]
      YAML
    end
    let(:invalid_config_error) do
      <<~ERR.strip
        key 'updates.0.directory' is missing
        key 'updates.0.schedule.interval' is missing
        key 'updates.0.ignore.0.dependency-name' is missing
        key 'updates.0.milestone' must be a string
        key 'updates.0.vendor' must be boolean
      ERR
    end

    it "throws invalid configuration error" do
      expect { parser.call(config_yml) }.to raise_error(
        Dependabot::InvalidConfigurationError, /#{invalid_config_error}/
      )
    end
  end
end
