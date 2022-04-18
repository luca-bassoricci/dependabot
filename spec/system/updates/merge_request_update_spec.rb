# frozen_string_literal: true

describe "merge request update", :system, type: :system, epic: :system, feature: "merge request update" do
  subject(:update_mr) do
    Dependabot::MergeRequest::UpdateService.call(
      project_name: project_name,
      mr_iid: mr.iid,
      action: Dependabot::MergeRequest::UpdateService::RECREATE
    )
  end

  include_context "with system helper"

  let(:project) { create(:project_with_mr, dependency: "git") }
  let(:project_name) { project.name }
  let(:mr) { project.merge_requests.first }

  let(:mock_definitions) do
    [
      project_mock,
      branch_head_mock,
      file_tree_mock,
      dep_file_mock,
      branch_mock(dependency: mr.main_dependency),
      create_commits_mock(dependency: mr.main_dependency),
      mr_mock(iid: mr.iid, update_to: mr.update_to)
    ]
  end

  before do
    mock.add(*mock_definitions)
  end

  xit "updates single merge request" do
    update_mr

    expect_all_mocks_called
  end
end
