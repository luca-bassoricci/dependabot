# frozen_string_literal: true

describe "dependency updates", :system, type: :system, epic: :system do
  subject(:update_dependencies) do
    Dependabot::UpdateService.call(
      project_name: project.name,
      package_ecosystem: package_ecosystem,
      directory: directory,
      dependency_name: dependency_name
    )
  end

  include_context "with system helper"
  include_context "with dependabot helper"

  let(:project) { create(:project, config_yaml: config_yaml) }
  let(:project_name) { project.name }
  let(:package_ecosystem) { "bundler" }
  let(:directory) { "/" }
  let(:mrs) { project.reload.merge_requests }

  let(:config_yaml) do
    <<~YAML
      version: 2
      updates:
        - package-ecosystem: #{package_ecosystem}
          directory: "#{directory}"
          schedule:
            interval: daily
          commit-message:
            prefix: "dep"
            prefix-development: "bundler-dev"
            include: "scope"
          ignore:
            - dependency-name: "faker"
              update-types: ["version-update:semver-major"]
    YAML
  end

  before do
    mock.add(*mock_definitions)
  end

  context "with all dependencies", :aggregate_failures do
    let(:dependency_name) { nil }

    let(:mock_definitions) do
      [
        project_mock,
        branch_head_mock,
        file_tree_mock,
        dep_file_mock,
        create_branch_mock,
        labels_mock,
        mr_check_mock,
        branches_check_mock(dependency: "git"),
        branches_check_mock(dependency: "rubocop"),
        create_commits_mock(dependency: "git"),
        create_commits_mock(dependency: "rubocop"),
        create_mr_mock(dependency: "git", iid: 1),
        create_mr_mock(dependency: "rubocop", iid: 2)
      ]
    end

    it "updates dependencies and creates merge requests" do
      expect(update_dependencies).to eq({ mr: Set[1, 2], security_mr: Set.new })
      expect(mrs.map(&:main_dependency)).to eq(%w[git rubocop])
      expect_all_mocks_called
    end
  end

  context "with single dependency", :aggregate_failures do
    let(:dependency_name) { "git" }

    let(:mock_definitions) do
      [
        project_mock,
        branch_head_mock,
        file_tree_mock,
        dep_file_mock,
        create_branch_mock,
        labels_mock,
        mr_check_mock,
        branches_check_mock(dependency: "git"),
        create_commits_mock(dependency: "git"),
        create_mr_mock(dependency: "git", iid: 1)
      ]
    end

    it "updates single dependency and creates merge request" do
      expect(update_dependencies).to eq({ mr: Set[1], security_mr: Set.new })
      expect(mrs.map(&:main_dependency)).to eq(%w[git])
      expect_all_mocks_called
    end
  end
end
