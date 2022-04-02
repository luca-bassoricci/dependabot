# frozen_string_literal: true

describe "Project", :system, type: :system do
  include_context "with system helper"
  include_context "with dependabot helper"

  before do
    mock_project_create
  end

  it "adds a project" do
    post_json("/api/projects", { project: repo })

    expect_status(200)
    verify_mocks
  end
end
