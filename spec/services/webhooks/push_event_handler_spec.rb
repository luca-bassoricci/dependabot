# frozen_string_literal: true

describe Webhooks::PushEventHandler, :aggregate_failures, integration: true, epic: :services, feature: :webhooks do
  subject { described_class }

  include_context "with dependabot helper"

  let(:job) { instance_double("Sidekiq::Cron::Job", name: "#{repo}:bundler:/", destroy: true) }
  let(:project) { Project.new(name: repo, config: dependabot_config) }

  def commits(added: [], modified: [], removed: [])
    [{
      added: ["some_file.rb", *added],
      modified: ["some_file.rb", *modified],
      removed: ["some_file.rb", *removed]
    }]
  end

  before do
    allow(Sidekiq::Cron::Job).to receive(:all)
    allow(Cron::JobSync).to receive(:call)
    allow(Dependabot::Projects::Creator).to receive(:call) { project }

    project.save!
  end

  context "with non config changes" do
    it "skips scheduling jobs" do
      described_class.call(project_name: repo, commits: commits)

      expect(Sidekiq::Cron::Job).not_to have_received(:all)
      expect(Cron::JobSync).not_to have_received(:call)
    end
  end

  context "with removed configuration" do
    before do
      allow(Sidekiq::Cron::Job).to receive(:all).and_return([job])
    end

    it "removes project" do
      described_class.call(project_name: repo, commits: commits(removed: [DependabotConfig.config_filename]))

      expect(job).to have_received(:destroy)
      expect(Project.where(name: repo).first).to be_nil
    end
  end

  context "with config update" do
    it "triggers dependency update" do
      described_class.call(project_name: repo, commits: commits(modified: [DependabotConfig.config_filename]))

      expect(Dependabot::Projects::Creator).to have_received(:call).with(repo)
      expect(Cron::JobSync).to have_received(:call).with(project)
    end
  end
end
