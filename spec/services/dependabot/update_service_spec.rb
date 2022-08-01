# frozen_string_literal: true

require "octokit/rate_limit"

describe Dependabot::UpdateService, :integration, epic: :services, feature: :dependabot do
  subject(:update_dependencies) do
    described_class.call(
      project_name: project.name,
      package_ecosystem: package_manager,
      directory: "/",
      dependency_name: dependency_name
    )
  end

  include_context "with dependabot helper"

  let(:config_yaml) do
    <<~YAML
      version: 2
      fork: #{forked_project}
      registries:
        dockerhub:
          type: docker-registry
          url: registry.hub.docker.com
          username: octocat
          password: password
      updates:
        - package-ecosystem: bundler
          directory: "/"
          schedule:
            interval: weekly
          open-pull-requests-limit: #{mr_limit}
    YAML
  end

  let(:gitlab) do
    instance_double(
      "Gitlab::client",
      project: Gitlab::ObjectifiedHash.new({ "forked_from_project" => { "id" => 1 } }),
      close_issue: nil
    )
  end

  let(:config) { project.configuration }
  let(:config_entry) { config.entry(package_ecosystem: "bundler") }
  let(:credentials) { [*Dependabot::Credentials.call(nil), *registries.values] }

  let(:branch) { "master" }
  let(:dependency_name) { nil }
  let(:mr_limit) { 5 }
  let(:forked_project) { false }

  let(:mr) do
    Gitlab::ObjectifiedHash.new(iid: 1)
  end

  let(:rspec_dep) { instance_double("Dependabot::Dependency", name: "rspec") }
  let(:config_dep) { instance_double("Dependabot::Dependency", name: "config") }
  let(:dependencies) { [rspec_dep, config_dep] }

  let(:updated_rspec) do
    Dependabot::Dependencies::UpdatedDependency.new(
      dependency: instance_double(Dependabot::Dependency, name: "rspec"),
      dependency_files: [instance_double(Dependabot::DependencyFile)],
      state: Dependabot::Dependencies::UpdateChecker::HAS_UPDATES,
      updated_dependencies: ["updated_rspec"],
      updated_files: [],
      vulnerable: false,
      auto_merge_rules: nil
    )
  end

  let(:updated_config) do
    Dependabot::Dependencies::UpdatedDependency.new(
      dependency: dependency,
      dependency_files: [instance_double(Dependabot::DependencyFile)],
      state: Dependabot::Dependencies::UpdateChecker::HAS_UPDATES,
      updated_dependencies: ["updated_config"],
      updated_files: [],
      vulnerable: false,
      auto_merge_rules: nil
    )
  end

  let(:updated_deps) do
    [
      updated_rspec,
      updated_config
    ]
  end

  let(:config_mr_args) do
    {
      project: project,
      fetcher: fetcher,
      config_entry: config_entry,
      updated_dependency: updated_config,
      credentials: credentials
    }
  end

  let(:rspec_mr_args) do
    {
      project: project,
      fetcher: fetcher,
      config_entry: config_entry,
      updated_dependency: updated_rspec,
      credentials: credentials
    }
  end

  before do
    allow(Dependabot::Files::Fetcher).to receive(:call)
      .with(
        project_name: project.name,
        config_entry: config_entry,
        repo_contents_path: nil,
        credentials: credentials
      )
      .and_return(fetcher)

    allow(Dependabot::Files::Parser).to receive(:call)
      .with(
        source: fetcher.source,
        dependency_files: fetcher.files,
        repo_contents_path: nil,
        config_entry: config_entry,
        credentials: credentials
      )
      .and_return(dependencies)

    allow(Dependabot::Dependencies::UpdateChecker).to receive(:call)
      .with(
        dependency: rspec_dep,
        dependency_files: fetcher.files,
        config_entry: config_entry,
        repo_contents_path: nil,
        credentials: credentials
      )
      .and_return(updated_rspec)

    allow(Dependabot::Dependencies::UpdateChecker).to receive(:call)
      .with(
        dependency: config_dep,
        dependency_files: fetcher.files,
        config_entry: config_entry,
        repo_contents_path: nil,
        credentials: credentials
      )
      .and_return(updated_config)

    allow(Gitlab::ClientWithRetry).to receive(:current) { gitlab }
    allow(Gitlab::Vulnerabilities::IssueCreator).to receive(:call)
    allow(Dependabot::MergeRequest::CreateService).to receive(:call).and_return(mr)
  end

  context "with deployed version" do
    let(:project) { create(:project, config_yaml: config_yaml) }

    context "without specific dependency", :aggregate_failures do
      it "runs dependency updates for all defined dependencies" do
        update_dependencies

        expect(Dependabot::MergeRequest::CreateService).to have_received(:call).with(rspec_mr_args)
        expect(Dependabot::MergeRequest::CreateService).to have_received(:call).with(config_mr_args)
      end
    end

    context "with single specific dependency" do
      let(:dependency_name) { "rspec" }

      it "runs dependency update for specific dependency" do
        update_dependencies

        expect(Dependabot::MergeRequest::CreateService).to have_received(:call).once.with(rspec_mr_args)
      end
    end

    context "with dependency already up to date", :aggregate_failures do
      let!(:saved_mr) do
        create(
          :merge_request,
          project: project,
          id: 1,
          iid: 1,
          main_dependency: rspec_dep.name,
          state: "opened",
          branch: "mr-branch",
          directory: "/"
        )
      end

      let(:updated_rspec) do
        Dependabot::Dependencies::UpdatedDependency.new(
          dependency: instance_double(Dependabot::Dependency, name: "rspec"),
          dependency_files: [instance_double(Dependabot::DependencyFile)],
          state: Dependabot::Dependencies::UpdateChecker::UP_TO_DATE
        )
      end

      before do
        allow(Gitlab::BranchRemover).to receive(:call)
      end

      it "closes mr for up to date dependency" do
        update_dependencies

        expect(saved_mr.reload.state).to eq("closed")
        expect(Gitlab::BranchRemover).to have_received(:call).with(project.name, saved_mr.branch)
      end
    end

    # rubocop:disable RSpec/NestedGroups
    context "with vulnerable dependency" do
      let(:package_version) { "1.0.0" }
      let(:vulnerable) { true }
      let(:dependency_name) { Faker::Alphanumeric.unique.alpha(number: 10) }

      let(:dependency_file) { instance_double(Dependabot::DependencyFile, support_file: false) }
      let(:vulnerability) { build(:vulnerability, package: dependency_name, vulnerable_version_range: range) }
      let(:vulnerabilities) { [vulnerability] }

      let(:updated_dep) do
        Dependabot::Dependencies::UpdatedDependency.new(
          dependency_files: [dependency_file],
          state: Dependabot::Dependencies::UpdateChecker::UPDATE_IMPOSSIBLE,
          vulnerabilities: vulnerabilities,
          vulnerable: vulnerable,
          dependency: instance_double(
            Dependabot::Dependency,
            name: dependency_name,
            package_manager: package_manager,
            version: package_version
          )
        )
      end

      let(:dependencies) { [updated_dep] }

      before do
        allow(Dependabot::Dependencies::UpdateChecker).to receive(:call).and_return(updated_dep)
      end

      context "without already existing vulnerability issue" do
        let(:range) { "<= #{package_version}" }

        it "creates new vulnerability issue" do
          update_dependencies

          expect(Gitlab::Vulnerabilities::IssueCreator).to have_received(:call).with(
            project: project,
            vulnerability: vulnerability,
            dependency_file: dependency_file,
            assignees: nil
          )
        end
      end

      context "with obsolete vulnerability issue" do
        let(:vulnerable) { false }
        let(:range) { "< #{package_version}" }

        let(:vulnerability_issue) do
          create(
            :vulnerability_issue,
            package_ecosystem: vulnerability.package_ecosystem,
            package: dependency_name,
            project: project,
            vulnerability: vulnerability
          )
        end

        before do
          vulnerability_issue.vulnerability.save!
        end

        it "closes vulnerability issue" do
          update_dependencies

          expect(Gitlab::Vulnerabilities::IssueCreator).not_to have_received(:call)
          expect(gitlab).to have_received(:close_issue).with(project.name, vulnerability_issue.iid)
          expect(vulnerability_issue.reload.status).to eq("closed")
        end
      end
    end

    context "with mr limit" do
      let(:mr_limit) { 2 }

      let(:second_mr) { Gitlab::ObjectifiedHash.new(iid: 2) }
      let(:third_mr) { Gitlab::ObjectifiedHash.new(iid: 3) }

      let(:puma_dep) { instance_double("Dependabot::Dependency", name: "puma") }
      let(:rails_dep) { instance_double("Dependabot::Dependency", name: "rails") }

      let(:updated_puma) do
        Dependabot::Dependencies::UpdatedDependency.new(
          dependency: instance_double(Dependabot::Dependency, name: "puma"),
          dependency_files: [instance_double(Dependabot::DependencyFile)],
          state: Dependabot::Dependencies::UpdateChecker::HAS_UPDATES,
          updated_dependencies: ["updated_puma"],
          updated_files: [],
          vulnerable: true,
          auto_merge_rules: nil
        )
      end

      let(:updated_rails) do
        Dependabot::Dependencies::UpdatedDependency.new(
          dependency: instance_double(Dependabot::Dependency, name: "rails"),
          dependency_files: [instance_double(Dependabot::DependencyFile)],
          state: Dependabot::Dependencies::UpdateChecker::HAS_UPDATES,
          updated_dependencies: ["updated_rails"],
          updated_files: [],
          vulnerable: false,
          auto_merge_rules: nil
        )
      end

      before do
        allow(Dependabot::Dependencies::UpdateChecker).to receive(:call)
          .with(
            dependency: puma_dep,
            dependency_files: fetcher.files,
            config_entry: config_entry,
            repo_contents_path: nil,
            credentials: credentials
          )
          .and_return(updated_puma)

        allow(Dependabot::Dependencies::UpdateChecker).to receive(:call)
          .with(
            dependency: rails_dep,
            dependency_files: fetcher.files,
            config_entry: config_entry,
            repo_contents_path: nil,
            credentials: credentials
          )
          .and_return(updated_rails)
      end

      context "with multiple dependencies in same mr" do
        let(:dependencies) { [rspec_dep, rails_dep, config_dep] }

        before do
          allow(Dependabot::MergeRequest::CreateService).to receive(:call).and_return(mr, mr, second_mr)
        end

        it "doesn't count towards mr limit" do
          update_dependencies

          expect(Dependabot::MergeRequest::CreateService).to have_received(:call).exactly(3).times
        end
      end

      context "with mr count over the limit" do
        let(:dependencies) { [rspec_dep, rails_dep, config_dep] }

        before do
          allow(Dependabot::MergeRequest::CreateService).to receive(:call).and_return(mr, second_mr)
        end

        it "counts unique merge request towards mr limit" do
          update_dependencies

          expect(Dependabot::MergeRequest::CreateService).to have_received(:call).twice
        end
      end

      context "with mr count over the limit but with vulnerable dependency" do
        let(:dependencies) { [rspec_dep, puma_dep, config_dep] }

        before do
          allow(Dependabot::MergeRequest::CreateService).to receive(:call).and_return(mr, second_mr, third_mr)
        end

        it "still updates vulnerable dependency" do
          update_dependencies

          expect(Dependabot::MergeRequest::CreateService).to have_received(:call).exactly(3).times
        end
      end
    end
    # rubocop:enable RSpec/NestedGroups
  end

  context "with errors" do
    let(:project) { create(:project, config_yaml: config_yaml) }

    before do
      allow(Dependabot::Files::Parser).to receive(:call).and_raise(error)
    end

    context "with github too many requests error" do
      let(:error) { Octokit::TooManyRequests }

      it "handles error" do
        expect { update_dependencies }.to raise_error(
          Dependabot::TooManyRequestsError,
          "GitHub API rate limit exceeded! See: https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting"
        )
      end
    end

    context "with external code execution error" do
      let(:error) { Dependabot::UnexpectedExternalCode }

      it "handles error" do
        expect { update_dependencies }.to raise_error(Dependabot::ExternalCodeExecutionError, <<~MSG)
          Unexpected external code execution detected.
          Option 'insecure-external-code-execution' must be set to 'allow' for entry:
            package_ecosystem - '#{package_manager}'
            directory - '/'
        MSG
      end
    end

    context "with missing config entry" do
      let(:error) { StandardError }
      let(:package_manager) { "docker" }

      it "raises missing config entry error" do
        expect { update_dependencies }.to raise_error(
          error,
          "Configuration is missing entry with package-ecosystem: #{package_manager}, directory: /"
        )
      end
    end
  end

  context "with standalone version" do
    let(:project) { build(:project, config_yaml: config_yaml) }
    let(:arg_keys) { %i[fetcher config updated_dependency] }
    let(:create_calls) { [] }

    before do
      allow(Dependabot::Config::Fetcher).to receive(:call).with(project.name) { config }
      allow(Dependabot::MergeRequest::CreateService).to receive(:call) do |args|
        create_calls << args
        mr
      end
    end

    around do |example|
      with_env("SETTINGS__STANDALONE" => "true") { example.run }
    end

    context "without fork configuration", :aggregate_failures do
      it "runs dependency update for repository" do
        update_dependencies

        expect(Dependabot::MergeRequest::CreateService).to have_received(:call).twice
        expect(create_calls.first).to include(rspec_mr_args.slice(:fetcher, :config, :updated_dependency))
        expect(create_calls.last).to include(config_mr_args.slice(:fetcher, :config, :updated_dependency))
        expect(create_calls.first[:project].name).to eq(project.name)
        expect(create_calls.first[:project].forked_from_id).to be_nil
      end
    end

    context "with fork configuration" do
      let(:forked_project) { true }

      it "run dependency update for forked repository" do
        update_dependencies

        expect(Dependabot::MergeRequest::CreateService).to have_received(:call).twice
        expect(create_calls.first[:project].forked_from_id).to eq(1)
      end
    end
  end
end
