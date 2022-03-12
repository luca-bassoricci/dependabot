# frozen_string_literal: true

describe Dependabot::UpdateService, integration: true, epic: :services, feature: :dependabot do
  subject(:update_dependencies) do
    described_class.call(
      project_name: repo,
      package_ecosystem: package_manager,
      directory: "/",
      dependency_name: dependency_name
    )
  end

  include_context "with dependabot helper"

  let(:gitlab) do
    instance_double("Gitlab::client", project: Gitlab::ObjectifiedHash.new({
      "forked_from_project" => { "id" => 1 }
    }))
  end

  let(:fetcher) do
    instance_double("Dependabot::FileFetcher", files: "files", source: "source")
  end

  let(:branch) { "master" }
  let(:config) { Config.new(dependabot_config) }
  let(:config_entry) { config.first }
  let(:project) { Project.new(name: repo, config: config) }
  let(:dependency_name) { nil }

  let(:mr) do
    Gitlab::ObjectifiedHash.new(iid: 1)
  end

  let(:rspec_dep) { instance_double("Dependabot::Dependency", name: "rspec") }
  let(:config_dep) { instance_double("Dependabot::Dependency", name: "config") }
  let(:dependencies) { [rspec_dep, config_dep] }

  let(:updated_rspec) do
    Dependabot::Dependencies::UpdatedDependency.new(
      name: "rspec",
      updated_dependencies: ["updated_rspec"],
      updated_files: [],
      vulnerable: false,
      security_advisories: [],
      auto_merge_rules: nil
    )
  end

  let(:updated_config) do
    Dependabot::Dependencies::UpdatedDependency.new(
      name: "config",
      updated_dependencies: ["updated_config"],
      updated_files: [],
      vulnerable: false,
      security_advisories: [],
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
      config: config_entry,
      updated_dependency: updated_config
    }
  end

  let(:rspec_mr_args) do
    {
      project: project,
      fetcher: fetcher,
      config: config_entry,
      updated_dependency: updated_rspec
    }
  end

  before do
    allow(Dependabot::Files::Fetcher).to receive(:call).with(repo, config_entry, nil) { fetcher }

    allow(Dependabot::Files::Parser).to receive(:call)
      .with(
        source: fetcher.source,
        dependency_files: fetcher.files,
        repo_contents_path: nil,
        config: config_entry
      )
      .and_return(dependencies)

    allow(Dependabot::Dependencies::UpdateChecker).to receive(:call)
      .with(
        dependency: rspec_dep,
        dependency_files: fetcher.files,
        config: config_entry,
        repo_contents_path: nil
      )
      .and_return(updated_rspec)

    allow(Dependabot::Dependencies::UpdateChecker).to receive(:call)
      .with(
        dependency: config_dep,
        dependency_files: fetcher.files,
        config: config_entry,
        repo_contents_path: nil
      )
      .and_return(updated_config)

    allow(Dependabot::MergeRequest::CreateService).to receive(:call).and_return(mr)
  end

  context "with deployed version" do
    before do
      project.save!
    end

    context "without specific dependency" do
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

    # rubocop:disable RSpec/NestedGroups
    context "with mr limit" do
      let(:config) { Config.new([dependabot_config.first.merge(open_merge_requests_limit: 2)]) }
      let(:second_mr) { Gitlab::ObjectifiedHash.new(iid: 2) }
      let(:third_mr) { Gitlab::ObjectifiedHash.new(iid: 3) }

      let(:puma_dep) { instance_double("Dependabot::Dependency", name: "puma") }
      let(:rails_dep) { instance_double("Dependabot::Dependency", name: "rails") }

      let(:updated_puma) do
        Dependabot::Dependencies::UpdatedDependency.new(
          name: "puma",
          updated_dependencies: ["updated_puma"],
          updated_files: [],
          vulnerable: true,
          security_advisories: [],
          auto_merge_rules: nil
        )
      end

      let(:updated_rails) do
        Dependabot::Dependencies::UpdatedDependency.new(
          name: "rails",
          updated_dependencies: ["updated_rails"],
          updated_files: [],
          vulnerable: false,
          security_advisories: [],
          auto_merge_rules: nil
        )
      end

      before do
        allow(Dependabot::Dependencies::UpdateChecker).to receive(:call)
          .with(
            dependency: puma_dep,
            dependency_files: fetcher.files,
            config: config_entry,
            repo_contents_path: nil
          )
          .and_return(updated_puma)

        allow(Dependabot::Dependencies::UpdateChecker).to receive(:call)
          .with(
            dependency: rails_dep,
            dependency_files: fetcher.files,
            config: config_entry,
            repo_contents_path: nil
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
    before do
      allow(Dependabot::Files::Parser).to receive(:call).and_raise(error)

      project.save!
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
          "Configuration missing entry with package-ecosystem: #{package_manager}, directory: /"
        )
      end
    end
  end

  context "with standalone version" do
    let(:arg_keys) { %i[fetcher config updated_dependency] }
    let(:create_calls) { [] }

    before do
      allow(Gitlab).to receive(:client) { gitlab }

      allow(Dependabot::Config::Fetcher).to receive(:call).with(repo) { config }
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
        expect(create_calls.first[:project].name).to eq(repo)
        expect(create_calls.first[:project].forked_from_id).to be_nil
      end
    end

    context "with fork configuration" do
      before do
        config_entry[:fork] = true
      end

      it "run dependency update for forked repository" do
        update_dependencies

        expect(Dependabot::MergeRequest::CreateService).to have_received(:call).twice
        expect(create_calls.first[:project].forked_from_id).to eq(1)
      end
    end
  end
end
