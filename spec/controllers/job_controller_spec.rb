# frozen_string_literal: true

describe JobController, :integration, type: :request, epic: :controllers, feature: "jobs" do
  include_context "with dependabot helper"

  let(:project) { Project.create!(name: repo, configuration: Configuration.new(updates: updates_config)) }
  let(:config_entry) { updates_config.first }

  let(:update_job) do
    UpdateJob.new(
      project_id: project._id,
      package_ecosystem: config_entry[:package_ecosystem],
      directory: config_entry[:directory],
      cron: config_entry[:cron]
    )
  end

  before do
    allow(DependencyUpdateJob).to receive(:perform_later)

    update_job.save!
  end

  it "enqueues dependency update job", :aggregate_failures do
    put("/jobs/#{update_job._id}/execute")

    expect_status(302)
    expect(DependencyUpdateJob).to have_received(:perform_later).with(
      project_name: project.name,
      package_ecosystem: update_job.package_ecosystem,
      directory: update_job.directory
    )
  end
end
