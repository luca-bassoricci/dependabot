# frozen_string_literal: true

describe Dependabot::ProjectCreator, integration: true, epic: :services, feature: :dependabot do
  include_context "with dependabot helper"

  let(:branch) { "master" }
  let(:gitlab) { instance_double("Gitlab::client") }
  let(:project) { Project.new(name: repo) }
  let(:hook_id) { Faker::Number.number(digits: 10) }
  let(:upstream_hook_id) { hook_id }
  let(:config_exists?) { true }
  let(:gitlab_project) { OpenStruct.new(default_branch: branch, forked_from_project: { id: 1 }) }

  before do
    allow(Gitlab).to receive(:client) { gitlab }
    allow(gitlab).to receive(:project).with(repo) { OpenStruct.new(default_branch: branch) }
    allow(Gitlab::Config::Checker).to receive(:call).with(repo, branch) { config_exists? }
    allow(Gitlab::Config::Fetcher).to receive(:call).with(repo, branch, update_cache: true) { raw_config }
    allow(Gitlab::Hooks::Creator).to receive(:call) { hook_id }
    allow(Gitlab::Hooks::Updater).to receive(:call) { hook_id }
    allow(Gitlab::Hooks::Finder).to receive(:call) { upstream_hook_id }
  end

  context "with dependabot url configured" do
    context "without existing project" do
      let(:upstream_hook_id) { nil }

      it "creates new project and hook" do
        described_class.call(repo)

        saved_project = Project.find_by(name: repo)
        aggregate_failures do
          expect(saved_project.name).to eq(repo)
          expect(saved_project.symbolized_config).to eq(dependabot_config.map(&:deep_symbolize_keys))
          expect(saved_project.webhook_id).to eq(hook_id)
        end
      end
    end

    context "with hook creation disabled" do
      include_context "with config helper"

      it "skips hook creation" do
        with_env("SETTINGS__CREATE_PROJECT_HOOK" => "false") do
          described_class.call(repo)

          expect(Project.find_by(name: repo).webhook_id).to be_nil
        end
      end
    end

    context "with existing project" do
      it "updates existing project and hook" do
        project.webhook_id = hook_id
        project.save!

        described_class.call(repo)
        aggregate_failures do
          expect(project.reload.symbolized_config).to eq(dependabot_config.map(&:deep_symbolize_keys))
          expect(Gitlab::Hooks::Updater).to have_received(:call).with(repo, branch, hook_id)
          expect(Gitlab::Hooks::Creator).not_to have_received(:call)
          expect(Gitlab::Hooks::Finder).not_to have_received(:call)
        end
      end

      it "updates existing upstream hook" do
        project.save!

        described_class.call(repo)
        aggregate_failures do
          expect(project.reload.symbolized_config).to eq(dependabot_config.map(&:deep_symbolize_keys))
          expect(Gitlab::Hooks::Updater).to have_received(:call).with(repo, branch, hook_id)
          expect(Gitlab::Hooks::Creator).not_to have_received(:call)
        end
      end
    end
  end

  context "without dependabot url configured" do
    before do
      allow(AppConfig).to receive(:dependabot_url).and_return(nil)
    end

    it "skips hook creation" do
      described_class.call(repo)

      aggregate_failures do
        expect(Gitlab::Hooks::Creator).not_to have_received(:call)
        expect(Gitlab::Hooks::Updater).not_to have_received(:call)
      end
    end
  end

  context "without config file in repository" do
    let(:config_exists?) { false }

    it "creates new project with empty config" do
      described_class.call(repo)

      expect(Project.find_by(name: repo).config).to be_empty
    end
  end
end
