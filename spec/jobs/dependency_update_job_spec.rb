# frozen_string_literal: true

describe DependencyUpdateJob, :integration, epic: :jobs, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  let(:project) { Project.new(name: args["project_name"]) }

  let(:update_job) do
    UpdateJob.find_by(
      project_id: project._id,
      package_ecosystem: args["package_ecosystem"],
      directory: args["directory"]
    )
  end

  let(:args) do
    {
      "project_name" => Faker::Alphanumeric.unique.alpha(number: 15),
      "package_ecosystem" => "bundler",
      "directory" => "/"
    }
  end

  before do
    allow(Dependabot::UpdateService).to receive(:call)

    project.save!
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
      expect(update_job.last_executed).not_to be_nil
    end
  end

  context "with errors" do
    before do
      allow(Dependabot::UpdateService).to receive(:call).and_raise(StandardError.new("Some error!"))
    end

    it "saves run errors", :aggregate_failures do
      expect { job.perform_now(args) }.to raise_error(StandardError, "Some error!")
      expect(update_job.run_errors).to eq(["Some error!"])
    end
  end
end
