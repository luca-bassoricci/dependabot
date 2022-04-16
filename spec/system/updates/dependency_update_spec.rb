# frozen_string_literal: true

describe "dependency updates", :system, type: :system, epic: :system, feature: "dependency updates" do
  subject(:update_dependencies) do
    Dependabot::UpdateService.call(
      project_name: project.name,
      package_ecosystem: package_ecosystem,
      directory: directory,
      dependency_name: dependency_name
    )
  end

  include_context "with system helper"

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
          rebase-strategy: "all"
    YAML
  end

  let(:project) { create(:project, config_yaml: config_yaml) }
  let(:project_name) { project.name }
  let(:package_ecosystem) { "bundler" }
  let(:dependency_name) { nil }
  let(:directory) { "/" }
  let(:mrs) { project.reload.merge_requests }

  context "without existing mrs", :aggregate_failures do
    let(:mock_definitions) do
      [
        project_mock,
        branch_head_mock,
        file_tree_mock,
        dep_file_mock,
        create_branch_mock,
        labels_mock,
        mr_check_mock,
        no_branch_mock(dependency: "git"),
        no_branch_mock(dependency: "rubocop"),
        create_commits_mock(dependency: "git"),
        create_commits_mock(dependency: "rubocop"),
        create_mr_mock(dependency: "git", iid: 1),
        create_mr_mock(dependency: "rubocop", iid: 2)
      ]
    end

    it "creates dependency update mrs" do
      expect(update_dependencies).to eq({ mr: Set[1, 2], security_mr: Set.new })
      expect(mrs.map(&:main_dependency)).to eq(%w[git rubocop])
      expect_all_mocks_called
    end
  end

  context "with existing mrs" do
    let(:project) { create(:project_with_mr, config_yaml: config_yaml, dependency: "git") }
    let(:mr_cop) { create(:merge_request, project: project, main_dependency: "rubocop") }
    let(:mr_git) { mrs.first }

    let(:mock_definitions) do
      [
        project_mock,
        branch_head_mock,
        file_tree_mock,
        dep_file_mock,
        mr_check_mock,
        branch_mock(dependency: mr_cop.main_dependency),
        branch_mock(dependency: mr_git.main_dependency),
        create_commits_mock(dependency: mr_git.main_dependency),
        find_mr_mock(dependency: mr_git.main_dependency, id: mr_git.id, iid: mr_git.iid),
        find_mr_mock(dependency: mr_cop.main_dependency, id: mr_cop.id, iid: mr_cop.iid, has_conflicts: false),
        mr_mock(iid: mr_git.iid, update_to: mr_git.update_to),
        rebase_mock(iid: mr_cop.iid)
      ]
    end

    it "updates merge requests" do
      expect(update_dependencies).to eq({ mr: Set[mr_git.iid, mr_cop.iid], security_mr: Set.new })
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
        no_branch_mock(dependency: "git"),
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
