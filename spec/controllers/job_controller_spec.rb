# frozen_string_literal: true

describe JobController, :integration, epic: :controllers do
  include_context "with rack_test"
  include_context "with dependabot helper"

  let(:config) { dependabot_config.first }
  let(:project) { Project.create!(name: repo, config: dependabot_config) }
  let(:update_job) do
    UpdateJob.new(
      project_id: project._id,
      package_ecosystem: config[:package_ecosystem],
      directory: config[:directory],
      cron: config[:cron]
    )
  end

  before do
    allow(DependencyUpdateJob).to receive(:perform_later)

    update_job.save!
  end

  it "enqueues dependency update job" do
    put("/jobs/#{update_job._id}/execute")

    expect(last_response.status).to eq(302)
    expect(DependencyUpdateJob).to have_received(:perform_later).with(
      project_name: project.name,
      package_ecosystem: update_job.package_ecosystem,
      directory: update_job.directory
    )
  end
end
