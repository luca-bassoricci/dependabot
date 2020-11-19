# frozen_string_literal: true

describe Webhooks::PushEventHandler do
  include_context "dependabot"

  let(:job) { double("job", name: "#{repo}:bundler:/", destroy: true) }

  def commits(added: [], modified: [], removed: [])
    [{
      added: ["some_file.rb", *added],
      modified: ["some_file.rb", *modified],
      removed: ["some_file.rb", *removed]
    }]
  end

  subject { described_class }

  before do
    allow(Sidekiq::Cron::Job).to receive(:all)
    allow(Scheduler::DependencyUpdateScheduler).to receive(:call)

    Project.create!(name: repo, config: dependabot_config)
  end

  context "non config changes" do
    it "skip scheduling jobs" do
      subject.call(repo, commits)

      aggregate_failures do
        expect(Sidekiq::Cron::Job).not_to have_received(:all)
        expect(Scheduler::DependencyUpdateScheduler).to_not have_received(:call)
        expect(Project.find_by(name: repo)).to be_truthy
      end
    end
  end

  context "removed configuration" do
    before do
      allow(Sidekiq::Cron::Job).to receive(:all).and_return([job])
    end

    it "removes project" do
      subject.call(repo, commits(removed: [Settings.config_filename]))

      aggregate_failures do
        expect(job).to have_received(:destroy)
        expect(Project.where(name: repo).first).to be_nil
      end
    end
  end

  context "config update" do
    it "triggers dependency update" do
      subject.call(repo, commits(modified: [Settings.config_filename]))

      aggregate_failures do
        expect(Scheduler::DependencyUpdateScheduler).to have_received(:call).with(repo)
        expect(Project.where(name: repo).first).to_not be_nil
      end
    end
  end
end
