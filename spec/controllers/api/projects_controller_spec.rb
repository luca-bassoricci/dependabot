# frozen_string_literal: true

describe Api::ProjectsController, :aggregate_failures, epic: :controllers do
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

    it "lists registered projects" do
      get(path)

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq([project.sanitized_hash].to_json)
    end
  end

  describe "#show" do
    before do
      project.save!
    end

    it "returns single project", :integration do
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

    it "creates project and jobs" do
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

  describe "#update" do
    before do
      project.save!
    end

    it "updates project", :integration do
      put_json("#{path}/#{project.id}", { name: "updated-name" })

      project.reload

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(project.sanitized_hash.to_json)
      expect(project.name).to eq("updated-name")
    end
  end

  describe "#destroy" do
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
