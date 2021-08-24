# frozen_string_literal: true

describe DependabotController, :integration, epic: :controllers do
  include_context "with rack_test"
  include_context "with dependabot helper"

  let(:project) { Project.create!(name: repo, config: dependabot_config) }
  let(:config) { dependabot_config.first }
  let(:update_job) do
    UpdateJob.new(
      project_id: project._id,
      package_ecosystem: config[:package_ecosystem],
      directory: config[:directory],
      cron: config[:cron]
    )
  end

  before do
    update_job.save!
  end

  it "returns list of jobs" do
    get("/")

    expect(last_response.status).to eq(200)
  end
end
