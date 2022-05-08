# frozen_string_literal: true

describe Dependabot::Dependencies::UpdatedDependency, epic: :services, feature: :dependabot do
  subject(:updated_dependency) do
    described_class.new(
      dependency: dependency,
      dependency_files: [instance_double(Dependabot::DependencyFile)],
      state: Dependabot::Dependencies::UpdateChecker::HAS_UPDATES,
      updated_dependencies: updated_dependencies,
      updated_files: updated_files,
      vulnerable: false,
      auto_merge_rules: merge_rules
    )
  end

  include_context "with dependabot helper"

  let(:name) { "config" }
  let(:merge_rules) { nil }
  let(:vulnerability) { build(:vulnerability) }

  describe "auto-merge" do
    context "without auto-merge configured" do
      it { expect(updated_dependency).not_to be_auto_mergeable }
    end

    context "with all dependencies ignored" do
      let(:merge_rules) do
        { ignore: [{ dependency_name: "*" }] }
      end

      it { expect(updated_dependency).not_to be_auto_mergeable }
    end

    context "with all dependencies allowed" do
      let(:merge_rules) do
        { allow: [{ dependency_name: "*" }] }
      end

      it { expect(updated_dependency).to be_auto_mergeable }
    end

    context "with explicit dependency name allowed" do
      let(:merge_rules) do
        { allow: [{ dependency_name: "config" }] }
      end

      it { expect(updated_dependency).to be_auto_mergeable }
    end

    context "with matching semver allowed" do
      let(:merge_rules) do
        {
          allow: [{
            dependency_name: "config",
            update_types: ["version-update:semver-minor"]
          }]
        }
      end

      it { expect(updated_dependency).to be_auto_mergeable }
    end

    context "with non matching semver allowed" do
      let(:merge_rules) do
        {
          allow: [{
            dependency_name: "config",
            update_types: ["version-update:semver-major"]
          }]
        }
      end

      it { expect(updated_dependency).not_to be_auto_mergeable }
    end

    context "with explicit dependency name ignored" do
      let(:merge_rules) do
        { ignore: [{ dependency_name: "config" }] }
      end

      it { expect(updated_dependency).not_to be_auto_mergeable }
    end

    context "with matching semver ignored" do
      let(:merge_rules) do
        {
          ignore: [{
            dependency_name: "config",
            update_types: ["version-update:semver-minor"]
          }]
        }
      end

      it { expect(updated_dependency).not_to be_auto_mergeable }
    end

    context "with ignore overriding allowed config" do
      let(:merge_rules) do
        {
          allow: [{
            dependency_name: "*"
          }],
          ignore: [{
            dependency_name: "config",
            update_types: ["version-update:semver-minor"]
          }]
        }
      end

      it { expect(updated_dependency).not_to be_auto_mergeable }
    end

    context "with one of the merge request dependencies ignored" do
      let(:merge_rules) do
        {
          ignore: [{
            dependency_name: "rspec",
            update_types: ["version-update:semver-minor"]
          }]
        }
      end
      let(:updated_dependencies) do
        [
          Dependabot::Dependency.new(
            name: dependency.name,
            package_manager: dependency.package_manager,
            previous_requirements: [dependency.requirements.first],
            previous_version: dependency.version,
            version: "2.2.1",
            requirements: [dependency.requirements.first.merge({ requirement: "~> 2.2.1" })]
          ),
          Dependabot::Dependency.new(
            name: "rspec",
            package_manager: dependency.package_manager,
            previous_requirements: [requirement: "~> 3.10.0", groups: [:default], source: nil, file: "Gemfile"],
            previous_version: "3.10.0",
            version: "3.11.0",
            requirements: [requirement: "~> 3.11.0", groups: [:default], source: nil, file: "Gemfile"]
          )
        ]
      end

      it { expect(updated_dependency).not_to be_auto_mergeable }
    end
  end

  describe "versions" do
    it "returns current versions for all updated dependencies" do
      expect(updated_dependency.current_versions).to eq("config-2.2.1")
    end

    it "returns previous versions for all updated dependencies" do
      expect(updated_dependency.previous_versions).to eq("config-2.1.0")
    end
  end
end
