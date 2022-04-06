# frozen_string_literal: true

describe Webhooks::PushEventHandler, :aggregate_failures, integration: true, epic: :services, feature: :webhooks do
  subject { described_class }

  let(:job) { instance_double("Sidekiq::Cron::Job", name: "#{project.name}:bundler:/", destroy: true) }
  let(:project) { create(:project) }

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
  end

  context "with non config changes" do
    it "skips scheduling jobs" do
      described_class.call(project_name: project.name, commits: commits)

      expect(Sidekiq::Cron::Job).not_to have_received(:all)
      expect(Cron::JobSync).not_to have_received(:call)
    end
  end

  context "with removed configuration" do
    before do
      allow(Sidekiq::Cron::Job).to receive(:all).and_return([job])
    end

    it "removes project" do
      described_class.call(project_name: project.name, commits: commits(removed: [DependabotConfig.config_filename]))

      expect(job).to have_received(:destroy)
      expect(Project.where(name: project.name).first).to be_nil
    end
  end

  context "with config update" do
    it "triggers dependency update" do
      described_class.call(project_name: project.name, commits: commits(modified: [DependabotConfig.config_filename]))

      expect(Dependabot::Projects::Creator).to have_received(:call).with(project.name)
      expect(Cron::JobSync).to have_received(:call).with(project)
    end
  end
end
