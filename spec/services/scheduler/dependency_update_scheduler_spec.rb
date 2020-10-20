# frozen_string_literal: true

describe Scheduler::DependencyUpdateScheduler do
  include_context "dependabot"

  let(:job) { double("job", name: "#{repo}:bundler:#{directory}", save: true, enque!: true) }
  let(:removed_job) { double("removed_job", name: "#{repo}:docker:/", destroy: true) }
  let(:repo) { "dependabot-gitlab" }
  let(:package_manager) { "bundler" }
  let(:directory) { "/" }

  subject { described_class }

  before do
    allow(Gitlab::ConfigFetcher).to receive(:call).with(repo).and_return(raw_config)
    allow(Sidekiq::Cron::Job).to receive(:new)
      .with(
        name: "#{repo}:bundler:#{directory}",
        cron: "00 02 * * sun Europe/Riga",
        class: "DependencyUpdateJob",
        args: { "repo" => repo, "package_ecosystem" => package_manager, "directory" => directory },
        active_job: true,
        description: "Update bundler dependencies for #{repo} in #{directory}"
      )
      .and_return(job)
    allow(Rails.logger).to receive(:error)
  end

  context "unchanged config" do
    before do
      allow(Sidekiq::Cron::Job).to receive(:all) { [job] }
    end

    it "saves and runs job" do
      allow(job).to receive(:valid?).and_return(true)

      expect(subject.call(repo)).to eq([job])
    end

    it "logs error of invalid job" do
      allow(job).to receive(:valid?).and_return(false)

      expect(subject.call(repo)).to eq([job])
      expect(Rails.logger).to have_received(:error)
    end
  end

  context "changed config" do
    before do
      allow(Sidekiq::Cron::Job).to receive(:all) { [job, removed_job] }
      allow(job).to receive(:valid?).and_return(true)
    end

    it "removes package ecosystem not present in config" do
      expect(subject.call(repo)).to eq([job])
      expect(removed_job).to have_received(:destroy)
    end
  end
end
