# frozen_string_literal: true

describe DependencyUpdateJob do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  let(:args) { { "repo" => "test-repo", "package_ecosystem" => "bundler" } }

  before do
    allow(DependencyUpdater).to receive(:call)
  end

  it "queues job" do
    expect { job.perform_later(args) }.to have_enqueued_job(job)
      .with(args)
      .on_queue("default")
  end

  it "performs enqued job" do
    perform_enqueued_jobs { job.perform_later(args) }

    expect(DependencyUpdater).to have_received(:call).with(args)
  end
end
