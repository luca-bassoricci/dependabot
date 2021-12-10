# frozen_string_literal: true

describe Api::ProjectsController, epic: :controllers, integration: true do
  include_context "with rack_test"
  include_context "with dependabot helper"

  let(:path) { "/api/projects" }

  let(:project) do
    Project.new(
      name: "#{Faker::Alphanumeric.unique.alpha(number: 5)}/#{Faker::Alphanumeric.unique.alpha(number: 5)}",
      config: dependabot_config,
      id: Faker::Number.number(digits: 10)
    )
  end

  describe "#index" do
    before do
      allow(Project).to receive(:all).and_return([project])
    end

    it "lists registered projects", :aggregate_failures do
      get(path)

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq([project.sanitized_hash].to_json)
    end
  end

  describe "#show", :integration do
    before do
      project.save!
    end

    it "returns single project" do
      get("#{path}/#{CGI.escape(project.name)}")

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(project.sanitized_hash.to_json)
    end
  end

  describe "#create" do
    before do
      allow(Dependabot::ProjectCreator).to receive(:call) { project }
      allow(Cron::JobSync).to receive(:call).with(project)
    end

    it "creates project and jobs", :aggregate_failures do
      post_json(path, { project: project.name })

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(project.sanitized_hash.to_json)
      expect(Dependabot::ProjectCreator).to have_received(:call).with(project.name)
      expect(Cron::JobSync).to have_received(:call).with(project)
    end

    it "handles incorrect request" do
      post_json(path, {})

      expect(last_response.status).to eq(400)
    end
  end

  describe "#destroy", :aggregate_failures do
    before do
      allow(Dependabot::ProjectRemover).to receive(:call)
    end

    it "removes registered project and jobs" do
      delete("#{path}/#{project.id}")

      expect(last_response.status).to eq(204)
      expect(Dependabot::ProjectRemover).to have_received(:call).with(project.id)
    end
  end
end
