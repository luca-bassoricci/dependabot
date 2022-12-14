# frozen_string_literal: true

describe Dependabot::Dependencies::UpdateChecker, :integration, epic: :services, feature: :dependabot do
  subject(:update_checker) do
    described_class.call(
      dependency: dependency,
      dependency_files: fetcher.files,
      config_entry: config_entry,
      repo_contents_path: nil,
      credentials: credentials
    )
  end

  include_context "with dependabot helper"

  let(:checker) { instance_double("Dependabot::Bundler::UpdateChecker") }
  let(:rule_handler) { instance_double("Dependabot::RuleHandler") }
  let(:latest_version) { "2.2.1" }
  let(:vulnerable) { false }
  let(:up_to_date) { false }
  let(:unlocked_or_can_be) { true }
  let(:can_update_own_unlock) { true }
  let(:can_update_all_unlock) { true }
  let(:can_update_none_unlock) { true }
  let(:versioning_strategy) { :bump_versions }
  let(:can_update) { true }
  let(:credentials) { [*Dependabot::Credentials.call(nil), *registries.values] }
  let(:advisories) { [] }

  let(:skipped_dep) do
    Dependabot::Dependencies::UpdatedDependency.new(
      dependency: dependency,
      dependency_files: fetcher.files,
      state: Dependabot::Dependencies::UpdateChecker::SKIPPED,
      vulnerable: vulnerable,
      auto_merge_rules: auto_merge_rules
    )
  end

  let(:up_to_date_dep) do
    Dependabot::Dependencies::UpdatedDependency.new(
      dependency: dependency,
      dependency_files: fetcher.files,
      state: Dependabot::Dependencies::UpdateChecker::UP_TO_DATE,
      vulnerable: vulnerable,
      auto_merge_rules: auto_merge_rules
    )
  end

  let(:update_impossible_dep) do
    Dependabot::Dependencies::UpdatedDependency.new(
      dependency: dependency,
      dependency_files: fetcher.files,
      state: Dependabot::Dependencies::UpdateChecker::UPDATE_IMPOSSIBLE,
      vulnerable: vulnerable,
      auto_merge_rules: auto_merge_rules
    )
  end

  let(:config_entry) do
    {
      **updates_config.first,
      allow: allow_conf,
      ignore: ignore_conf,
      versioning_strategy: versioning_strategy
    }
  end

  let(:checker_args) do
    args = {
      dependency: dependency,
      dependency_files: fetcher.files,
      credentials: credentials,
      ignored_versions: [],
      raise_on_ignored: true,
      security_advisories: advisories,
      options: config_entry[:updater_options]
    }
    args[:requirements_update_strategy] = versioning_strategy if versioning_strategy != :lockfile_only
    args
  end

  before do
    allow(Dependabot::Files::Updater).to receive(:call).with(
      dependencies: updated_dependencies,
      dependency_files: fetcher.files,
      repo_contents_path: nil,
      credentials: credentials,
      config_entry: config_entry
    ).and_return(updated_files)

    allow(Dependabot::Dependencies::RuleHandler).to receive(:new).with(
      dependency: dependency,
      checker: checker,
      config_entry: config_entry
    ).and_return(rule_handler)
    allow(rule_handler).to receive(:allowed?) { can_update }

    allow(Dependabot::Bundler::UpdateChecker).to receive(:new).with(checker_args) { checker }
    allow(checker).to receive(:vulnerable?) { vulnerable }
    allow(checker).to receive(:up_to_date?) { up_to_date }
    allow(checker).to receive(:requirements_unlocked_or_can_be?) { unlocked_or_can_be }
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :own) { can_update_own_unlock }
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :all) { can_update_all_unlock }
    allow(checker).to receive(:can_update?).with(requirements_to_unlock: :none) { can_update_none_unlock }
    allow(checker).to receive(:latest_version) { Gem::Version.new(latest_version) }
    allow(checker).to receive(:conflicting_dependencies).and_return([])
  end

  context "when update version is ignored" do
    before do
      allow(checker).to receive(:ignored_versions).and_return([">= 2.0"])
      allow(checker).to receive(:up_to_date?).and_raise(Dependabot::AllVersionsIgnored)
    end

    it "returns dep skipped" do
      expect(update_checker).to eq(skipped_dep)
    end
  end

  context "when nothing to update" do
    context "when dependency up to date" do
      let(:up_to_date) { true }

      it "returns dep up to date" do
        expect(update_checker).to eq(up_to_date_dep)
      end
    end

    context "when update not possible with requirements unlocked" do
      let(:can_update_own_unlock) { false }
      let(:can_update_all_unlock) { false }

      it "returns dep update impossible" do
        expect(update_checker).to eq(update_impossible_dep)
      end
    end

    context "when update not possible with requirements locked" do
      let(:unlocked_or_can_be) { false }
      let(:can_update_none_unlock) { false }

      it "returns dep update impossible" do
        expect(update_checker).to eq(update_impossible_dep)
      end
    end

    context "when update not allowed by rules" do
      let(:can_update) { false }

      it "returns dep skipped" do
        expect(update_checker).to eq(skipped_dep)
      end
    end
  end

  context "when dependency can be updated" do
    let(:updated_deps) do
      Dependabot::Dependencies::UpdatedDependency.new(
        dependency: dependency,
        dependency_files: fetcher.files,
        state: Dependabot::Dependencies::UpdateChecker::HAS_UPDATES,
        updated_files: updated_files,
        updated_dependencies: updated_dependencies,
        vulnerable: checker.vulnerable?,
        auto_merge_rules: auto_merge_rules
      )
    end

    before do
      allow(checker).to receive(:latest_version) { latest_version }
      allow(checker).to receive(:security_advisories).and_return(advisories)
      allow(checker).to receive(:updated_dependencies) { updated_dependencies }
    end

    context "when only lockfile updates are allowed" do
      let(:versioning_strategy) { :lockfile_only }

      it "returns updated dependencies" do
        expect(update_checker).to eq(updated_deps)
        expect(checker).to have_received(:updated_dependencies).with(requirements_to_unlock: :none)
      end
    end

    context "when no requirements to unlock" do
      let(:unlocked_or_can_be) { false }

      it "returns updated dependencies" do
        expect(update_checker).to eq(updated_deps)
        expect(checker).to have_received(:updated_dependencies).with(requirements_to_unlock: :none)
      end
    end

    context "when own requirements to unlock" do
      it "returns updated dependencies" do
        expect(update_checker).to eq(updated_deps)
        expect(checker).to have_received(:updated_dependencies).with(requirements_to_unlock: :own)
      end
    end

    context "when all requirements to unlock" do
      let(:can_update_own_unlock) { false }

      it "returns updated dependencies" do
        expect(update_checker).to eq(updated_deps)
        expect(checker).to have_received(:updated_dependencies).with(requirements_to_unlock: :all)
      end
    end

    context "when vulnerability exists" do
      let(:advisories) do
        array_including(kind_of(Dependabot::SecurityAdvisory))
      end

      let(:vulnerability) do
        Vulnerability.new(
          package: dependency.name,
          package_ecosystem: config_entry[:package_ecosystem],
          package_manager: config_entry[:package_manager],
          vulnerable_version_range: "> 1.0.0",
          first_patched_version: "2.0.0"
        )
      end

      let(:received_advisory) do
        Dependabot::SecurityAdvisory.new(
          dependency_name: dependency.name,
          package_manager: package_manager,
          vulnerable_versions: [vulnerability.vulnerable_version_range],
          safe_versions: [vulnerability.first_patched_version]
        )
      end

      before do
        allow(Vulnerability).to receive(:where)
          .with(
            package: dependency.name,
            package_ecosystem: config_entry[:package_ecosystem],
            withdrawn_at: nil
          )
          .and_return([vulnerability])
      end

      it "passes advisories to update checker", :aggregate_failures do
        expect(update_checker.vulnerabilities.first).to eq(vulnerability)

        expect(Dependabot::Bundler::UpdateChecker).to have_received(:new) do |args|
          advisory = args[:security_advisories].first

          expect(advisory.dependency_name).to eq(dependency.name)
          expect(advisory.package_manager).to eq(package_manager)
          expect(advisory.vulnerable_versions).to eq(received_advisory.vulnerable_versions)
          expect(advisory.safe_versions).to eq(received_advisory.safe_versions)
        end
      end
    end
  end
end
