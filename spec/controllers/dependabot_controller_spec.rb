# frozen_string_literal: true

describe DependabotController, :integration, epic: :controllers, type: :controller do
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
    allow(Project).to receive(:not).and_return([project])

    update_job.save!
  end

  it "returns index page", :aggregate_failures do
    get(:index)

    expect_status(200)
    expect(response).to render_template(:index)
  end
end
