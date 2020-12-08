# frozen_string_literal: true

describe Dependabot::ProjectCreator do
  include_context "with dependabot helper"

  let(:branch) { "master" }
  let(:gitlab) { instance_double("Gitlab::client") }
  let(:project) { Project.new(name: repo, webhook_id: 1) }
  let(:hook_id) { 1 }
  let(:config_exists?) { true }

  before do
    allow(Gitlab).to receive(:client) { gitlab }
    allow(gitlab).to receive(:project).with(repo) { OpenStruct.new(default_branch: branch) }
    allow(Gitlab::ConfigChecker).to receive(:call).with(repo, branch) { config_exists? }
    allow(Gitlab::ConfigFetcher).to receive(:call).with(repo, branch) { raw_config }
    allow(Gitlab::Hooks::Creator).to receive(:call) { hook_id }
    allow(Gitlab::Hooks::Updater).to receive(:call) { hook_id }
  end

  context "with dependabot url configured" do
    it "creates new project" do
      described_class.call(repo)

      saved_project = Project.find_by(name: repo)
      aggregate_failures do
        expect(saved_project).not_to be_nil
        expect(saved_project.symbolized_config).to eq(dependabot_config)
      end
    end

    it "creates and saves hook" do
      described_class.call(repo)

      saved_project = Project.find_by(name: repo)
      aggregate_failures do
        expect(saved_project.webhook_id).to eq(1)
        expect(Gitlab::Hooks::Creator).to have_received(:call).with(kind_of(Project), branch)
        expect(Gitlab::Hooks::Updater).not_to have_received(:call)
      end
    end

    it "updates existing project and hook" do
      project.save!

      described_class.call(repo)
      aggregate_failures do
        expect(project.reload.symbolized_config).to eq(dependabot_config)
        expect(Gitlab::Hooks::Updater).to have_received(:call).with(project, branch)
        expect(Gitlab::Hooks::Creator).not_to have_received(:call)
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
