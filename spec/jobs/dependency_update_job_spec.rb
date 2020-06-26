# frozen_string_literal: true

describe DependencyUpdateJob do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later(args) }

  let(:args) { { "repo" => "test-repo", "package_manager" => "bundler" } }

  it "queues job" do
    expect { job }.to have_enqueued_job(described_class)
      .with(args)
      .on_queue("default")
  end

  it "executes perform" do
    expect(DependencyUpdater).to receive(:call).with(args)

    perform_enqueued_jobs { job }
  end
end
