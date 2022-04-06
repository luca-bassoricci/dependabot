# frozen_string_literal: true

describe JobController, :integration, type: :request, epic: :controllers, feature: "jobs" do
  let(:project) { create(:project) }
  let(:update_job) { project.update_jobs.first }

  before do
    allow(DependencyUpdateJob).to receive(:perform_later)
  end

  it "enqueues dependency update job", :aggregate_failures do
    put("/jobs/#{update_job.id}/execute")

    expect_status(302)
    expect(DependencyUpdateJob).to have_received(:perform_later).with(
      project_name: project.name,
      package_ecosystem: update_job.package_ecosystem,
      directory: update_job.directory
    )
  end
end
