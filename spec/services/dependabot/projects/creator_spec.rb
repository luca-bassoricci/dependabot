# frozen_string_literal: true

describe Dependabot::Projects::Creator, integration: true, epic: :services, feature: :dependabot do
  subject(:create_project) { described_class.call(repo) }

  include_context "with dependabot helper"

  let(:branch) { "master" }
  let(:gitlab) { instance_double("Gitlab::client") }
  let(:project) { Project.new(name: repo) }
  let(:hook_id) { Faker::Number.number(digits: 10) }
  let(:upstream_hook_id) { hook_id }
  let(:config_exists?) { true }
  let(:config) { Config.new(dependabot_config.map(&:deep_stringify_keys)) }

  let(:gitlab_project) do
    Gitlab::ObjectifiedHash.new(
      id: 1,
      web_url: "project-url",
      default_branch: branch,
      forked_from_project: { id: 1 }
    )
  end

  let(:persisted_project) do
    Project.find_by(name: repo)
  end

  before do
    allow(Gitlab).to receive(:client) { gitlab }
    allow(gitlab).to receive(:project).with(repo) { gitlab_project }
    allow(Gitlab::ConfigFile::Checker).to receive(:call).with(repo, branch) { config_exists? }
    allow(Gitlab::ConfigFile::Fetcher).to receive(:call).with(repo, branch) { raw_config }
    allow(Gitlab::Hooks::Creator).to receive(:call) { hook_id }
    allow(Gitlab::Hooks::Updater).to receive(:call) { hook_id }
    allow(Gitlab::Hooks::Finder).to receive(:call) { upstream_hook_id }
  end

  context "with dependabot url configured" do
    context "without existing project", :aggregate_failures do
      let(:upstream_hook_id) { nil }

      it "creates new project and hook" do
        expect(create_project).to eq(persisted_project)
        expect(persisted_project.name).to eq(repo)
        expect(persisted_project.config).to eq(config)
        expect(persisted_project.webhook_id).to eq(hook_id)
      end
    end

    context "with hook creation disabled" do
      it "skips hook creation" do
        with_env("SETTINGS__CREATE_PROJECT_HOOK" => "false") do
          create_project

          expect(persisted_project.webhook_id).to be_nil
        end
      end
    end

    context "with existing project", :aggregate_failures do
      it "updates existing project and hook" do
        project.webhook_id = hook_id
        project.save!

        expect(create_project).to eq(persisted_project)
        expect(persisted_project.config).to eq(config)

        expect(Gitlab::Hooks::Updater).to have_received(:call).with(repo, branch, hook_id)
        expect(Gitlab::Hooks::Creator).not_to have_received(:call)
        expect(Gitlab::Hooks::Finder).not_to have_received(:call)
      end

      it "updates existing upstream hook and local webhook id" do
        project.save!

        expect(create_project).to eq(persisted_project)
        expect(persisted_project.config).to eq(config)
        expect(persisted_project.webhook_id).to eq(upstream_hook_id)

        expect(Gitlab::Hooks::Updater).to have_received(:call).with(repo, branch, hook_id)
        expect(Gitlab::Hooks::Creator).not_to have_received(:call)
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

      expect(persisted_project.config).to be_empty
    end
  end
end
