# frozen_string_literal: true

describe Dependabot::ProjectRegistration, integration: true, epic: :services, feature: :dependabot do
  let(:job_name) { "Project Registration" }
  let(:job_args) do
    {
      name: job_name,
      cron: AppConfig.project_registration_cron,
      class: "ProjectRegistrationJob",
      active_job: true,
      description: "Automatically register projects for update"
    }
  end
  let(:registration_job) { Sidekiq::Cron::Job.new(**job_args) }
  let(:created_job) { Sidekiq::Cron::Job.find(job_name) }

  before do
    allow(AppConfig).to receive(:project_registration) { mode }
  end

  after do
    Sidekiq::Cron::Job.destroy(job_name)
  end

  def job_params(job)
    job.to_hash.slice(:name, :klass, :cron, :description, :args)
  end

  context "with manual mode" do
    let(:mode) { "manual" }

    context "without existing job" do
      let(:job) { Sidekiq::Cron::Job.new }

      it "does not create project registration job" do
        described_class.call

        expect(created_job.name).to be_nil
      end
    end

    context "with existing job" do
      before do
        Sidekiq::Cron::Job.create(**job_args)
      end

      it "deletes job" do
        described_class.call

        expect(created_job.name).to be_nil
      end
    end
  end

  context "with system_hook mode" do
    let(:mode) { "system_hook" }
    let(:job) { Sidekiq::Cron::Job.new }

    it "does not create project registration job" do
      described_class.call

      expect(created_job.name).to be_nil
    end
  end

  context "with automatic mode" do
    let(:mode) { "automatic" }

    context "without existing job" do
      it "creates project registration job" do
        described_class.call

        expect(job_params(created_job)).to eq(job_params(registration_job))
      end
    end

    context "with existing job and unchanged cron" do
      before do
        Sidekiq::Cron::Job.create(**job_args)
      end

      it "does not update existing job" do
        described_class.call

        expect(job_params(created_job)).to eq(job_params(registration_job))
      end
    end

    context "with existing job and changed cron" do
      before do
        Sidekiq::Cron::Job.create(**job_args, cron: "*/5 * * * *")
      end

      it "updates existing job" do
        described_class.call

        expect(job_params(created_job)).to eq(job_params(registration_job))
      end
    end
  end
end
