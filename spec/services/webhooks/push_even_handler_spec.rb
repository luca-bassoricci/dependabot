# frozen_string_literal: true

describe Webhooks::PushEventHandler do
  let(:job) { double("job") }
  let(:project) { "dependabot-gitlab" }

  def push_params(added: [], modified: [], removed: [])
    {
      project: { path_with_namespace: project },
      commits: [{
        added: ["some_file.rb", *added],
        modified: ["some_file.rb", *modified],
        removed: ["some_file.rb", *removed]
      }]
    }
  end

  it "skips non config modifications" do
    expect(Sidekiq::Cron::Job).not_to receive(:all)
    expect(Scheduler::DependencyUpdateScheduler).not_to receive(:call)

    Webhooks::PushEventHandler.call(push_params)
  end

  it "removes job on configuration delete" do
    allow(Sidekiq::Cron::Job).to receive(:all).and_return([job])

    expect(job).to receive(:name).and_return("#{project}:bundler:/")
    expect(job).to receive(:destroy)

    Webhooks::PushEventHandler.call(push_params(removed: [Settings.config_filename]))
  end

  it "calls dependency update scheduler" do
    expect(Scheduler::DependencyUpdateScheduler).to receive(:call).with(project)

    Webhooks::PushEventHandler.call(push_params(modified: [Settings.config_filename]))
  end
end
