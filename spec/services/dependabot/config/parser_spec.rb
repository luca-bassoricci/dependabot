# frozen_string_literal: true

require "tempfile"

describe Dependabot::Config::Parser, epic: :services, feature: :configuration do
  subject(:parsed_config) { described_class.call(config_yml, project_name) }

  include_context "with dependabot helper"

  context "with valid configuration" do
    let(:config_yml) { File.read("spec/fixture/gitlab/responses/dependabot.yml") }

    it "returns parsed configuration" do
      expect(parsed_config).to eq({ updates: updates_config, registries: registries })
    end
  end

  context "with base config template" do
    let(:config_yml) do
      <<~YAML
        version: 2
        registries:
          npm:
            type: npm-registry
            url: https://npm.pkg.github.com
            token: test_token
        updates:
          - package-ecosystem: bundler
            directory: "/"
            schedule:
              interval: daily
      YAML
    end

    let(:base_template) do
      Tempfile.new("template.yml").tap do |f|
        f.write(<<~YML)
          updates:
            milestone: "4"
            rebase-strategy:
              on-approval: true
        YML
        f.close
      end
    end

    before do
      allow(DependabotConfig).to receive(:config_base_template).and_return(base_template.path)
    end

    it "merges base configuration" do
      expect(parsed_config[:registries]).to eq({
        "npm" => { "registry" => "npm.pkg.github.com", "token" => "test_token", "type" => "npm_registry" }
      })
      expect(parsed_config[:updates].first).to include({
        milestone: "4",
        rebase_strategy: { strategy: "auto", on_approval: true, with_assignee: nil }
      })
    end
  end

  context "with registries" do
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
              interval: daily
              hours: 9-17
            registries:
              - npm
      YAML
    end

    it "sets reject_external_code: true" do
      expect(parsed_config[:updates].first[:reject_external_code]).to eq(true)
    end
  end

  context "without registries" do
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
      expect(parsed_config[:updates].first[:reject_external_code]).to eq(false)
    end
  end

  context "with disabled vulnerabilities alerts" do
    let(:config_yml) do
      <<~YAML
        version: 2
        vulnerability-alerts:
          enabled: false
        updates:
          - package-ecosystem: bundler
            directory: "/"
            schedule:
              interval: weekly
      YAML
    end

    it "sets vulnerability alerts to disabled" do
      expect(parsed_config[:updates].first.dig(:vulnerability_alerts, :enabled)).to eq(false)
    end
  end

  context "with valid config and rebase on approvals" do
    let(:config_yml) do
      <<~YAML
        version: 2
        updates:
          - package-ecosystem: bundler
            directory: "/"
            schedule:
              interval: weekly
            rebase-strategy:
              on-approval: true
      YAML
    end

    it "sets 'auto' strategy by default" do
      expect(parsed_config[:updates].first[:rebase_strategy]).to eq({
        strategy: "auto",
        on_approval: true,
        with_assignee: nil
      })
    end
  end

  context "with missing or incorrect types in config" do
    let(:config_yml) do
      <<~YAML
        version: 2
        updates:
          - package-ecosystem: bundler
            vendor: "true"
            schedule:
              interval: daily
              time: "19:00"
            milestone: 4
            ignore:
              - versions: ["3.x", "4.x"]
            commit-message:
              prefix: "dep"
              trailers:
                - changelog: "dep"
      YAML
    end

    let(:invalid_config_error) do
      <<~ERR.strip
        key 'updates.0.directory' is missing
        key 'updates.0.ignore.0.dependency-name' is missing
        key 'updates.0.milestone' must be a string
        key 'updates.0.vendor' must be boolean
      ERR
    end

    it "throws invalid configuration error" do
      expect { parsed_config }.to raise_error(
        Dependabot::Config::InvalidConfigurationError, /#{invalid_config_error}/
      )
    end
  end

  context "with incorrect hours range format" do
    let(:config_yml) do
      <<~YAML
        version: 2
        updates:
          - package-ecosystem: bundler
            directory: "/"
            schedule:
              interval: weekly
              hours: "25"
      YAML
    end

    it "throws invalid format error" do
      expect { parsed_config }.to raise_error(
        Dependabot::Config::InvalidConfigurationError,
        "key 'schedule.hours.0' has invalid format, must match pattern '^\\d{1,2}-\\d{1,2}$'"
      )
    end
  end

  context "with incorrect hours range definition" do
    let(:config_yml) do
      <<~YAML
        version: 2
        updates:
          - package-ecosystem: bundler
            directory: "/"
            schedule:
              interval: weekly
              hours: "23-0"
      YAML
    end

    it "throws invalid format error" do
      expect { parsed_config }.to raise_error(
        Dependabot::Config::InvalidConfigurationError,
        "key 'schedule.hours.0' has invalid format, first number in range must be smaller or equal than second"
      )
    end
  end

  context "with invalid rebase-strategy configuration" do
    let(:config_yml) do
      <<~YAML
        version: 2
        updates:
          - package-ecosystem: bundler
            directory: "/"
            schedule:
              interval: weekly
            rebase-strategy:
              approval: true
      YAML
    end

    it "sets reject_external_code: false by default" do
      expect { parsed_config }.to raise_error(
        Dependabot::Config::InvalidConfigurationError,
        "key 'rebase-strategy.approval' is not allowed"
      )
    end
  end
end
