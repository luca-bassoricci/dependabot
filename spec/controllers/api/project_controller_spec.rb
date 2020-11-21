# frozen_string_literal: true

describe Api::ProjectController do
  include_context "rack_test"

  let(:project_name) { "dependabot-gitlab/dependabot" }
  let(:project) { Project.new(name: project_name) }

  before do
    allow(Dependabot::ProjectCreator).to receive(:call).with(project_name) { project }
    allow(Scheduler::DependencyUpdateScheduler).to receive(:call).with(project_name)
  end

  it "creates project and jobs" do
    post_json("/api/project", { project: project_name })

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq(project.to_json)
  end

  it "handles incorrect request" do
    post_json("/api/project", {})

    expect(last_response.status).to eq(400)
  end
end
