# frozen_string_literal: true

describe Api::ProjectsController, :aggregate_failures, {
  type: :request,
  epic: :controllers,
  feature: :api,
  story: :projects
} do
  include_context "with api helper"

  let(:path) { "/api/projects" }
  let(:project) { build(:project) }

  describe "#index" do
    before do
      allow(Project).to receive(:all).and_return([project])
    end

    it "lists registered projects" do
      get(path)

      expect_status(200)
      expect(response.body).to eq([project.to_hash].to_json)
    end
  end

  describe "#show", :integration do
    let(:project) { create(:project) }

    it "returns single project" do
      get("#{path}/#{CGI.escape(project.name)}")

      expect_status(200)
      expect(response.body).to eq(project.to_hash.to_json)
    end
  end

  describe "#create" do
    let(:project_access_token) { "test-token" }

    before do
      allow(Dependabot::Projects::Creator).to receive(:call) { project }
      allow(Cron::JobSync).to receive(:call).with(project)
    end

    it "creates project and jobs" do
      post_json(path, { project: project.name, gitlab_access_token: project_access_token })

      expect_status(200)
      expect(response.body).to eq(project.to_hash.to_json)
      expect(Dependabot::Projects::Creator).to have_received(:call).with(project.name, project_access_token)
      expect(Cron::JobSync).to have_received(:call).with(project)
    end

    it "handles incorrect request" do
      post_json(path, {})

      expect_status(400)
    end
  end

  describe "#update", :integration do
    let(:project) { create(:project) }

    it "updates project" do
      put_json("#{path}/#{project.id}", { name: "updated-name" })

      project.reload

      expect_status(200)
      expect(response.body).to eq(project.to_hash.to_json)
      expect(project.name).to eq("updated-name")
    end
  end

  describe "#destroy", :integration do
    let(:project) { create(:project) }

    it "removes registered project and jobs" do
      delete("#{path}/#{project.id}")

      expect_status(204)
      expect(Project.where(id: project.id).first).to be_nil
    end
  end
end
