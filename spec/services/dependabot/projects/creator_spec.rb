# frozen_string_literal: true

# rubocop:disable RSpec/NestedGroups
describe Dependabot::Projects::Creator, integration: true, epic: :services, feature: :dependabot do
  subject(:create_project) { described_class.call(project.name) }

  let(:config_yaml) do
    <<~YAML
      version: 2
      registries:
        dockerhub:
          type: docker-registry
          url: registry.hub.docker.com
          username: octocat
          password: password
      updates:
        - package-ecosystem: bundler
          directory: "/"
          schedule:
            interval: weekly
    YAML
  end

  let(:gitlab) { instance_double("Gitlab::client") }
  let(:project) { build(:project, config_yaml: config_yaml) }
  let(:branch) { "master" }
  let(:hook_id) { Faker::Number.number(digits: 10) }
  let(:upstream_hook_id) { hook_id }
  let(:config_exists?) { true }
  let(:config_entry) { project.configuration.entry(package_ecosystem: "bundler") }
  let(:registries) { project.configuration.registries }

  let(:gitlab_project) do
    Gitlab::ObjectifiedHash.new(
      id: project.id,
      web_url: "project-url",
      default_branch: branch,
      forked_from_project: { id: 1 }
    )
  end

  let(:persisted_project) do
    Project.find_by(name: project.name)
  end

  before do
    allow(Gitlab).to receive(:client) { gitlab }
    allow(gitlab).to receive(:project).with(project.name) { gitlab_project }
    allow(Gitlab::ConfigFile::Checker).to receive(:call).with(project.name, branch) { config_exists? }
    allow(Gitlab::ConfigFile::Fetcher).to receive(:call).with(project.name, branch) { config_yaml }
    allow(Gitlab::Hooks::Creator).to receive(:call) { hook_id }
    allow(Gitlab::Hooks::Updater).to receive(:call) { hook_id }
    allow(Gitlab::Hooks::Finder).to receive(:call) { upstream_hook_id }
  end

  context "with dependabot url configured" do
    context "without existing project", :aggregate_failures do
      let(:upstream_hook_id) { nil }

      it "creates new project and hook" do
        expect(create_project).to eq(persisted_project)
        expect(persisted_project.name).to eq(project.name)
        expect(persisted_project.configuration.entry(package_ecosystem: "bundler")).to eq(config_entry)
        expect(persisted_project.configuration.registries).to eq(registries)
        expect(persisted_project.webhook_id).to eq(hook_id)
      end
    end

    context "with hook creation disabled" do
      around do |example|
        with_env("SETTINGS__CREATE_PROJECT_HOOK" => "false") { example.run }
      end

      it "skips hook creation" do
        create_project

        expect(persisted_project.webhook_id).to be_nil
      end
    end

    context "with existing project", :aggregate_failures do
      context "with out of sync hooks" do
        it "updates existing project and hook" do
          project.webhook_id = hook_id
          project.save!

          expect(create_project).to eq(persisted_project)

          expect(Gitlab::Hooks::Updater).to have_received(:call).with(project.name, branch, hook_id)
          expect(Gitlab::Hooks::Creator).not_to have_received(:call)
          expect(Gitlab::Hooks::Finder).not_to have_received(:call)
        end

        it "updates existing upstream hook and local webhook id" do
          project.save!

          expect(create_project).to eq(persisted_project)
          expect(persisted_project.webhook_id).to eq(upstream_hook_id)

          expect(Gitlab::Hooks::Updater).to have_received(:call).with(project.name, branch, hook_id)
          expect(Gitlab::Hooks::Creator).not_to have_received(:call)
        end
      end

      context "with out of sync config" do
        let(:config_yaml) do
          <<~YAML
            version: 2
            updates:
              - package-ecosystem: bundler
                directory: "/test"
                schedule:
                  interval: weekly
          YAML
        end

        it "updates config" do
          project.save!

          expect(create_project).to eq(persisted_project)
          expect(persisted_project.configuration.entry(package_ecosystem: "bundler")).to eq(
            Dependabot::Config::Parser.call(config_yaml, project.name)[:updates].first
          )
        end
      end
    end
  end

  context "without dependabot url configured" do
    before do
      allow(AppConfig).to receive(:dependabot_url).and_return(nil)
    end

    it "skips hook creation", :aggregate_failures do
      create_project

      expect(Gitlab::Hooks::Creator).not_to have_received(:call)
      expect(Gitlab::Hooks::Updater).not_to have_received(:call)
    end
  end

  context "without config file in repository" do
    let(:config_exists?) { false }

    it "creates new project with empty config" do
      create_project

      expect(persisted_project.configuration).to be_nil
    end
  end
end
# rubocop:enable RSpec/NestedGroups
