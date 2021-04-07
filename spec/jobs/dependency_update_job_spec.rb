# frozen_string_literal: true

describe DependencyUpdateJob, epic: :jobs do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  let(:args) { { "project_name" => "test-repo", "package_ecosystem" => "bundler", "directory" => "/" } }

  before do
    allow(Dependabot::UpdateService).to receive(:call)
  end

  it "queues job" do
    expect { job.perform_later(args) }.to have_enqueued_job(job)
      .with(args)
      .on_queue("default")
  end

  it "performs enqued job" do
    perform_enqueued_jobs { job.perform_later(args) }

    expect(Dependabot::UpdateService).to have_received(:call).with(args)
  end

  it "raises error on blank argument" do
    expect { job.perform_now({ "directory" => "/", "package_ecosystem" => nil, "project_name" => "" }) }.to raise_error(
      ArgumentError, '["package_ecosystem", "project_name"] must not be blank'
    )
  end
end
