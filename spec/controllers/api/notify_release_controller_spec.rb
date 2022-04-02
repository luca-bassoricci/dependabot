# frozen_string_literal: true

describe Api::NotifyReleaseController, type: :request, epic: :controllers, feature: :api, story: "release notify" do
  subject(:request) do
    post_json("/api/notify_release", { name: dependency_name, package_ecosystem: package_ecosystem })
  end

  include_context "with api helper"
  include_context "with dependabot helper"

  let(:dependency_name) { "rspec" }
  let(:package_ecosystem) { "bundler" }

  let(:project_bundler) do
    Project.new(
      name: Faker::Alphanumeric.unique.alpha(number: 15),
      configuration: Configuration.new(updates: updates_config)
    )
  end

  let(:project_npm) do
    Project.new(
      name: Faker::Alphanumeric.unique.alpha(number: 15),
      configuration: Configuration.new(updates: [{ package_ecosystem: "npm", directory: "/" }])
    )
  end

  before do
    allow(NotifyReleaseJob).to receive(:perform_later)
  end

  context "with valid projects" do
    before do
      allow(Project).to receive(:all) { [project_bundler, project_npm] }

      request
    end

    it "triggers updates", :aggregate_failures do
      expect_status(200)
      expect_json(triggered: true)
      expect(NotifyReleaseJob).to have_received(:perform_later).with(
        dependency_name,
        package_ecosystem,
        [{ directory: updates_config.first[:directory], project_name: project_bundler.name }]
      )
    end
  end

  context "without valid projects" do
    let(:dependency_name) { "helm" }
    let(:package_ecosystem) { "terraform" }

    before do
      allow(Project).to receive(:all) { [project_npm] }

      request
    end

    it "returns error message", :aggregate_failures do
      expect_status(400)
      expect_json(status: 400, error: "No projects with configured '#{package_ecosystem}' found")
      expect(NotifyReleaseJob).not_to have_received(:perform_later)
    end
  end
end
