# frozen_string_literal: true

describe DependencyUpdateJob, epic: :jobs, integration: true do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  let(:args) do
    {
      "project_name" => Faker::Alphanumeric.unique.alpha(number: 15),
      "package_ecosystem" => "bundler",
      "directory" => "/"
    }
  end

  before do
    allow(Dependabot::UpdateService).to receive(:call)
  end

  context "without errors" do
    it "queues job" do
      expect { job.perform_later(args) }.to have_enqueued_job(job)
        .with(args)
        .on_queue("default")
    end

    it "performs enqued job" do
      perform_enqueued_jobs { job.perform_later(args) }

      expect(Dependabot::UpdateService).to have_received(:call).with(args)
    end
  end

  context "with errors" do
    before do
      allow(Dependabot::UpdateService).to receive(:call).and_raise(StandardError.new("Some error!"))
    end

    it "raises error on blank argument" do
      expect { job.perform_now({ "directory" => "/", "package_ecosystem" => nil, "project_name" => "" }) }.to(
        raise_error(ArgumentError, '["package_ecosystem", "project_name"] must not be blank')
      )
    end

    it "saves run errors" do
      saved_errors = -> { JobErrors.where(name: ApplicationHelper.execution_context_name(args)).first&.run_errors }

      expect { job.perform_now(args) }.to raise_error(StandardError, "Some error!")
      expect(saved_errors.call).to eq(["Some error!"])
    end
  end
end
