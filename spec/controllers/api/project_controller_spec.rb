# frozen_string_literal: true

describe Api::ProjectController do
  include_context "rack_test"

  let(:project) { "dependabot-gitlab/dependabot" }

  it "creates dependency update jobs" do
    expect(Scheduler::DependencyUpdateScheduler).to receive(:call).with(project).and_return([])

    post_json("/api/project", { project: project })

    expect(last_response.status).to eq(200)
  end

  it "handles incorrect request" do
    post_json("/api/project", {})

    expect(last_response.status).to eq(400)
  end
end
