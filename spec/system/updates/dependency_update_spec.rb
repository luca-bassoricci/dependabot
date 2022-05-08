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
  include_context "with dependabot helper"

  let(:config_yaml) do
    {
      "version" => 2,
      "updates" => [
        {
          "package-ecosystem" => package_ecosystem,
          "directory" => directory,
          "schedule" => {
            "interval" => "daily"
          },
          "commit-message" => {
            "prefix" => "dep",
            "prefix-development" => "bundler-dev",
            "include" => "scope"
          },
          "ignore" => ignored_deps,
          "rebase-strategy" => "all"
        }
      ]
    }.to_yaml
  end

  let(:ignored_deps) do
    [
      { "dependency-name" => "rspec-retry" },
      {
        "dependency-name" => "nokogiri",
        "update-types" => [
          "version-update:semver-patch",
          "version-update:semver-minor",
          "version-update:semver-major"
        ]
      }
    ]
  end

  let(:project) { create(:project, config_yaml: config_yaml) }
  let(:project_name) { project.name }
  let(:package_ecosystem) { "bundler" }
  let(:dependency_name) { nil }
  let(:directory) { "/" }
  let(:mrs) { project.reload.merge_requests }
  let(:vulnerabilities) { [] }

  before do
    allow(Vulnerability).to receive(:where) { vulnerabilities }
  end

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
        no_branch_mock(dependency: "faker"),
        no_branch_mock(dependency: "rubocop"),
        create_commits_mock(dependency: "faker"),
        create_commits_mock(dependency: "rubocop"),
        create_mr_mock(dependency: "faker", iid: 1),
        create_mr_mock(dependency: "rubocop", iid: 2)
      ]
    end

    it "creates dependency update mrs" do
      expect(update_dependencies).to eq({ mr: Set[1, 2], security_mr: Set.new })
      expect(mrs.map(&:main_dependency)).to eq(%w[faker rubocop])
      expect_all_mocks_called
    end
  end

  context "with existing mr" do
    let(:project) { create(:project_with_mr, config_yaml: config_yaml, dependency: "rspec-retry") }
    let(:mr) { mrs.first }

    let(:ignored_deps) do
      [
        { "dependency-name" => "rubocop" },
        { "dependency-name" => "faker" },
        { "dependency-name" => "nokogiri" }
      ]
    end

    let(:common_mock_definitions) do
      [
        project_mock,
        branch_head_mock,
        file_tree_mock,
        dep_file_mock,
        mr_check_mock,
        branch_mock(dependency: mr.main_dependency),
        find_mr_mock(dependency: mr.main_dependency, id: mr.id, iid: mr.iid, has_conflicts: has_conflicts)
      ]
    end

    context "with conflicts" do
      let(:has_conflicts) { true }

      let(:mock_definitions) do
        [
          *common_mock_definitions,
          mr_mock(iid: mr.iid, update_to: mr.update_to), # dependabot pr updater fetching existing mr
          create_commits_mock(dependency: mr.main_dependency)
        ]
      end

      it "recreates merge request" do
        expect(update_dependencies).to eq({ mr: Set[mr.iid], security_mr: Set.new })
        expect(mrs.map(&:main_dependency)).to eq([mr.main_dependency])
        expect_all_mocks_called
      end
    end

    context "without conflicts" do
      let(:has_conflicts) { false }

      let(:mock_definitions) do
        [
          *common_mock_definitions,
          rebase_mock(iid: mr.iid)
        ]
      end

      it "rebases merge request" do
        expect(update_dependencies).to eq({ mr: Set[mr.iid], security_mr: Set.new })
        expect(mrs.map(&:main_dependency)).to eq([mr.main_dependency])
        expect_all_mocks_called
      end
    end
  end

  context "with single dependency", :aggregate_failures do
    let(:dependency_name) { "faker" }

    let(:mock_definitions) do
      [
        project_mock,
        branch_head_mock,
        file_tree_mock,
        dep_file_mock,
        create_branch_mock,
        labels_mock,
        mr_check_mock,
        no_branch_mock(dependency: dependency_name),
        create_commits_mock(dependency: dependency_name),
        create_mr_mock(dependency: dependency_name, iid: 1)
      ]
    end

    it "updates single dependency and creates merge request" do
      expect(update_dependencies).to eq({ mr: Set[1], security_mr: Set.new })
      expect(mrs.map(&:main_dependency)).to eq([dependency_name])
      expect_all_mocks_called
    end
  end

  context "with existing security vulnerability" do
    let(:dependency_name) { "nokogiri" }
    let(:vulnerability) { build(:vulnerability) }
    let(:vulnerabilities) { [vulnerability] }

    context "with successfull dependency update" do
      let(:ignored_deps) do
        [
          { "dependency-name" => "rubocop" },
          { "dependency-name" => "faker" },
          { "dependency-name" => "rspec-retry" }
        ]
      end

      let(:mock_definitions) do
        [
          project_mock,
          branch_head_mock,
          file_tree_mock,
          dep_file_mock,
          create_branch_mock,
          labels_mock,
          mr_check_mock,
          no_branch_mock(dependency: dependency_name),
          create_commits_mock(dependency: dependency_name),
          create_mr_mock(dependency: dependency_name, iid: 1)
        ]
      end

      it "creates vulnerability fix merge request" do
        expect(update_dependencies).to eq({ mr: Set.new, security_mr: Set[1] })
        expect(mrs.map(&:main_dependency)).to eq([dependency_name])
        expect_all_mocks_called
      end
    end

    context "with unsuccessfull dependency update" do
      let(:ignored_deps) do
        [
          { "dependency-name" => "rubocop" },
          { "dependency-name" => "faker" },
          { "dependency-name" => "rspec-retry" },
          { "dependency-name" => "nokogiri" }
        ]
      end

      let(:mock_definitions) do
        [
          project_mock,
          branch_head_mock,
          file_tree_mock,
          dep_file_mock,
          vulnerability_issue_mock
        ]
      end

      it "creates vulnerability issue" do
        expect(update_dependencies).to eq({ mr: Set.new, security_mr: Set.new })
        expect_all_mocks_called
      end
    end
  end
end
