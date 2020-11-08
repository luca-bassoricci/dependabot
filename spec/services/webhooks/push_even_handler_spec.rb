# frozen_string_literal: true

describe Webhooks::PushEventHandler do
  include_context "dependabot"

  let(:job) { double("job", name: "#{repo}:bundler:/", destroy: true) }
  let(:payload) { push_params }

  def push_params(added: [], modified: [], removed: [])
    {
      project: { path_with_namespace: repo },
      commits: [{
        added: ["some_file.rb", *added],
        modified: ["some_file.rb", *modified],
        removed: ["some_file.rb", *removed]
      }]
    }
  end

  subject { described_class }

  before do
    allow(Sidekiq::Cron::Job).to receive(:all)
    allow(Scheduler::DependencyUpdateScheduler).to receive(:call)

    Project.create!(name: repo, config: [])
  end

  context "non config changes" do
    it "skip scheduling jobs" do
      subject.call(payload)

      aggregate_failures do
        expect(Sidekiq::Cron::Job).not_to have_received(:all)
        expect(Scheduler::DependencyUpdateScheduler).to_not have_received(:call)
        expect(Project.find_by(name: repo)).to be_truthy
      end
    end
  end

  context "removed configuration" do
    let(:payload) { push_params(removed: [Settings.config_filename]) }

    before do
      allow(Sidekiq::Cron::Job).to receive(:all).and_return([job])
    end

    it "removes project" do
      subject.call(payload)

      aggregate_failures do
        expect(job).to have_received(:destroy)
        expect(Project.where(name: repo).first).to be_nil
      end
    end
  end

  context "config update" do
    let(:payload) { push_params(modified: [Settings.config_filename]) }

    it "triggers dependency update" do
      subject.call(payload)

      aggregate_failures do
        expect(Scheduler::DependencyUpdateScheduler).to have_received(:call).with(repo)
        expect(Project.where(name: repo).first).to_not be_nil
      end
    end
  end
end
