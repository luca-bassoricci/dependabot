# frozen_string_literal: true

describe DependencyUpdateJob, :integration, type: :job, epic: :jobs, feature: "dependency updates" do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  let(:project) { create(:project) }
  let(:update_job) { project.update_jobs.first }
  let(:update_run) { update_job.reload.runs.last }

  let(:args) do
    {
      "project_name" => project.name,
      "package_ecosystem" => "bundler",
      "directory" => "/"
    }
  end

  before do
    allow(Dependabot::UpdateService).to receive(:call)

    RequestStore.clear!
  end

  context "without errors" do
    it "queues job" do
      expect { job.perform_later(args) }.to have_enqueued_job(job)
        .with(args)
        .on_queue("default")
    end

    it "performs enqued job and saves last enqued time", :aggregate_failures do
      perform_enqueued_jobs { job.perform_later(args) }

      expect(Dependabot::UpdateService).to have_received(:call).with(args.symbolize_keys)
      expect(update_run.created_at).not_to be_nil
    end
  end

  context "with errors" do
    before do
      allow(Dependabot::UpdateService).to receive(:call).and_raise(StandardError.new("Some error!"))
    end

    it "saves run errors", :aggregate_failures do
      expect { job.perform_now(args) }.to raise_error(StandardError, "Some error!")
      expect(update_run.failures.map(&:message)).to eq(["Some error!"])
    end
  end
end
