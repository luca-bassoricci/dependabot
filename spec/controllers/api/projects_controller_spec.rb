# frozen_string_literal: true

describe Api::ProjectsController, :aggregate_failures, epic: :controllers, type: :request do
  include_context "with api helper"
  include_context "with dependabot helper"

  let(:path) { "/api/projects" }

  let(:project) do
    Project.new(
      name: "#{Faker::Alphanumeric.unique.alpha(number: 5)}/#{Faker::Alphanumeric.unique.alpha(number: 5)}",
      configuration: Configuration.new(updates: updates_config),
      id: Faker::Number.number(digits: 10)
    )
  end

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

  describe "#show" do
    before do
      project.save!
    end

    it "returns single project", :integration do
      get("#{path}/#{CGI.escape(project.name)}")

      expect_status(200)
      expect(response.body).to eq(project.to_hash.to_json)
    end
  end

  describe "#create" do
    before do
      allow(Dependabot::Projects::Creator).to receive(:call) { project }
      allow(Cron::JobSync).to receive(:call).with(project)
    end

    it "creates project and jobs" do
      post_json(path, { project: project.name })

      expect_status(200)
      expect(response.body).to eq(project.to_hash.to_json)
      expect(Dependabot::Projects::Creator).to have_received(:call).with(project.name)
      expect(Cron::JobSync).to have_received(:call).with(project)
    end

    it "handles incorrect request" do
      post_json(path, {})

      expect_status(400)
    end
  end

  describe "#update" do
    before do
      project.save!
    end

    it "updates project", :integration do
      put_json("#{path}/#{project.id}", { name: "updated-name" })

      project.reload

      expect_status(200)
      expect(response.body).to eq(project.to_hash.to_json)
      expect(project.name).to eq("updated-name")
    end
  end

  describe "#destroy" do
    before do
      allow(Dependabot::Projects::Remover).to receive(:call)
    end

    it "removes registered project and jobs" do
      delete("#{path}/#{project.id}")

      expect_status(204)
      expect(Dependabot::Projects::Remover).to have_received(:call).with(project.id)
    end
  end
end
