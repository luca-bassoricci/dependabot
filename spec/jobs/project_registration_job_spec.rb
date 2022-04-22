# frozen_string_literal: true

describe ProjectRegistrationJob, epic: :jobs, type: :job, feature: "project registration" do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  before do
    allow(Dependabot::Projects::Registration::Service).to receive(:call)
  end

  it "queues job in project_registration queue" do
    expect { job.perform_later }.to have_enqueued_job(job).on_queue("project_registration")
  end

  it "runs job sync" do
    perform_enqueued_jobs { job.perform_later }

    expect(Dependabot::Projects::Registration::Service).to have_received(:call)
  end
end
