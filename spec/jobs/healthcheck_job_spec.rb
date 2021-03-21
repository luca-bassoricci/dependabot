# frozen_string_literal: true

describe HealthcheckJob, epic: :jobs do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  before do
    allow(FileUtils).to receive(:touch)
  end

  it "queues job" do
    expect { job.perform_later }.to have_enqueued_job(job).on_queue(HealthcheckConfig.queue)
  end

  it "performs enqued job" do
    perform_enqueued_jobs { job.perform_later }

    expect(FileUtils).to have_received(:touch).with(HealthcheckConfig.filename)
  end
end
