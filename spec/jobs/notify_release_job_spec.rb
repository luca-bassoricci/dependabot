# frozen_string_literal: true

describe NotifyReleaseJob, epic: :jobs do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  include_context "with dependabot helper"

  let(:dependency_name) { "rspec" }
  let(:package_ecosystem) { "bundler" }
  let(:project_name) { "project" }

  let(:configs) do
    [{
      project_name: project_name,
      directory: dependabot_config.first[:directory]
    }]
  end

  let(:args) do
    [dependency_name, package_ecosystem, configs]
  end

  before do
    allow(Dependabot::UpdateService).to receive(:call)
  end

  it "queues job in hooks queue" do
    expect { job.perform_later(*args) }.to have_enqueued_job(job).on_queue("hooks")
  end

  it "triggers updates" do
    perform_enqueued_jobs { job.perform_later(*args) }

    expect(Dependabot::UpdateService).to have_received(:call).with(
      dependency_name: dependency_name,
      package_ecosystem: package_ecosystem,
      project_name: project_name,
      directory: dependabot_config.first[:directory]
    )
  end
end
