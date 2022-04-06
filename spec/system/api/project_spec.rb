# frozen_string_literal: true

describe "Project", :system, type: :system, epic: :system, feature: :projects do
  include_context "with system helper"

  let(:project) { build(:project) }
  let(:project_name) { project.name }
  let(:created_project) { Project.where(name: project.name).first }
  let(:created_job) { created_project.update_jobs.first }

  before do
    mock.add(*mock_definitions)
  end

  context "with configuration file", :aggregate_failures do
    let(:mock_definitions) { [project_mock, hook_mock, set_hook_mock, present_config_mock, raw_config_mock] }

    it "adds a project" do
      post_json("/api/projects", { project: project.name })

      expect_status(200)
      expect(created_project).to be_truthy
      expect(created_job.package_ecosystem).to eq("bundler")
      expect(created_job.directory).to eq("/")
      expect_all_mocks_called
    end
  end

  context "without configuration file", :aggregate_failures do
    let(:mock_definitions) { [project_mock, hook_mock, set_hook_mock, missing_config_mock] }

    it "adds project without configuration" do
      post_json("/api/projects", { project: project.name })

      expect_status(200)
      expect(created_project).to be_truthy
      expect(created_project.configuration).to be_nil
      expect(created_job).to be_nil
      expect_all_mocks_called
    end
  end
end
