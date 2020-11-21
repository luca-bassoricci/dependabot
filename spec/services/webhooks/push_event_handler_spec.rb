# frozen_string_literal: true

describe Webhooks::PushEventHandler do
  subject { described_class }

  include_context "dependabot"

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
    allow(Scheduler::DependencyUpdateScheduler).to receive(:call)
    allow(Dependabot::ProjectCreator).to receive(:call) { project }

    project.save!
  end

  context "with non config changes" do
    it "skips scheduling jobs" do
      described_class.call(repo, commits)

      aggregate_failures do
        expect(Sidekiq::Cron::Job).not_to have_received(:all)
        expect(Scheduler::DependencyUpdateScheduler).not_to have_received(:call)
      end
    end
  end

  context "with removed configuration" do
    before do
      allow(Sidekiq::Cron::Job).to receive(:all).and_return([job])
    end

    it "removes project" do
      described_class.call(repo, commits(removed: [Settings.config_filename]))

      aggregate_failures do
        expect(job).to have_received(:destroy)
        expect(Project.where(name: repo).first).to be_nil
      end
    end
  end

  context "with config update" do
    it "triggers dependency update" do
      described_class.call(repo, commits(modified: [Settings.config_filename]))

      aggregate_failures do
        expect(Dependabot::ProjectCreator).to have_received(:call).with(repo)
        expect(Scheduler::DependencyUpdateScheduler).to have_received(:call).with(project)
      end
    end
  end
end
