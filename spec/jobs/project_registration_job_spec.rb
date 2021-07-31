# frozen_string_literal: true

describe ProjectRegistrationJob, epic: :jobs do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  before do
    allow(Gitlab::ProjectFinder).to receive(:call) { projects }
    allow(Dependabot::ProjectCreator).to receive(:call)
    allow(Cron::JobSync).to receive(:call)
  end

  it "queues job in project_registration queue" do
    expect { job.perform_later }.to have_enqueued_job(job).on_queue("project_registration")
  end

  context "without unregistered projects" do
    let(:projects) { [] }

    it "does not perform project registration" do
      perform_enqueued_jobs { job.perform_later }

      expect(Dependabot::ProjectCreator).not_to have_received(:call)
      expect(Cron::JobSync).not_to have_received(:call)
    end
  end

  context "with unregistered projects" do
    let(:projects) { %w[project_name_1 project_name_2] }
    let(:returned_projects) { %w[project_1 project_2] }

    before do
      allow(Dependabot::ProjectCreator).to receive(:call).and_return(*returned_projects)
    end

    it "registers projects and creates cron jobs" do
      perform_enqueued_jobs { job.perform_later }

      expect(Dependabot::ProjectCreator).to have_received(:call).with(projects[0])
      expect(Cron::JobSync).to have_received(:call).with(returned_projects[0])

      expect(Dependabot::ProjectCreator).to have_received(:call).with(projects[1])
      expect(Cron::JobSync).to have_received(:call).with(returned_projects[1])
    end
  end
end
