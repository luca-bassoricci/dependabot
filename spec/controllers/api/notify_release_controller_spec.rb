# frozen_string_literal: true

describe Api::NotifyReleaseController, epic: :controllers do
  include_context "with rack_test"
  include_context "with dependabot helper"

  let(:dependency_name) { "rspec" }
  let(:package_ecosystem) { "bundler" }

  let(:project_bundler) do
    Project.new(
      name: Faker::Alphanumeric.unique.alpha(number: 15),
      config: dependabot_config
    )
  end

  let(:project_npm) do
    Project.new(
      name: Faker::Alphanumeric.unique.alpha(number: 15),
      config: [{ package_ecosystem: "npm", directory: "/" }]
    )
  end

  before do
    allow(NotifyReleaseJob).to receive(:perform_later)
  end

  context "with valid projects" do
    before do
      allow(Project).to receive(:all) { [project_bundler, project_npm] }
    end

    it "triggers updates" do
      post_json("/api/notify_release", { name: dependency_name, package_ecosystem: package_ecosystem })

      aggregate_failures do
        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq({ triggered: true }.to_json)
        expect(NotifyReleaseJob).to have_received(:perform_later).with(
          dependency_name,
          package_ecosystem,
          [{ directory: dependabot_config.first[:directory], project_name: project_bundler.name }]
        )
      end
    end
  end

  context "without valid projects" do
    before do
      allow(Project).to receive(:all) { [project_npm] }
    end

    it "doesn't trigger updates" do
      post_json("/api/notify_release", { name: "helm", package_ecosystem: "terraform" })

      aggregate_failures do
        expect(last_response.status).to eq(204)

        expect(NotifyReleaseJob).not_to have_received(:perform_later)
      end
    end
  end
end
