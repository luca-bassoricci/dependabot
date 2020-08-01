# frozen_string_literal: true

describe Scheduler::DependencyUpdateScheduler do
  include_context "dependabot"

  let(:job) { double("job") }
  let(:repo) { "dependabot-gitlab" }

  before do
    allow(Gitlab::ConfigFetcher).to receive(:call).with(repo).and_return(raw_config)
  end

  it "saves and runs job" do
    expect(Sidekiq::Cron::Job).to receive(:new)
      .with(
        name: "#{repo}:bundler",
        cron: "00 02 * * sun Europe/Riga",
        class: "DependencyUpdateJob",
        args: { repo: repo, package_manager: "bundler" },
        active_job: true,
        description: "Update bundler dependencies for #{repo} in /"
      )
      .and_return(job)
    expect(job).to receive(:valid?).and_return(true)
    expect(job).to receive(:save).and_return(true)
    expect(job).to receive(:enque!).and_return(true)

    expect(Scheduler::DependencyUpdateScheduler.call(repo)).to eq([job])
  end

  it "logs error of invalid job" do
    expect(Sidekiq::Cron::Job).to receive(:new).and_return(job)
    expect(job).to receive(:valid?).and_return(false)
    expect_any_instance_of(Logger).to receive(:error)

    expect(Scheduler::DependencyUpdateScheduler.call(repo)).to eq([job])
  end
end
