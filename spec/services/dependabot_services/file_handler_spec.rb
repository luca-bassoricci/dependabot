# frozen_string_literal: true

describe "File handlers" do
  include_context "webmock"

  let(:package_manager) { "bundler" }
  let(:fetcher) { DependabotServices::FileFetcher.call(source: source, package_manager: package_manager) }
  let(:dependency) do
    Dependabot::Dependency.new(
      name: "config",
      package_manager: package_manager,
      version: "2.1.0",
      requirements: [requirement: "~> 2.1.0", groups: [:default], source: nil, file: "Gemfile"]
    )
  end

  before do
    stub_gitlab
  end

  context DependabotServices::FileFetcher do
    it "returns file fetcher" do
      expect(fetcher).to be_an_instance_of(Dependabot::Bundler::FileFetcher)
    end
  end

  context DependabotServices::FileParser do
    it "returns file parser" do
      actual_deps = DependabotServices::FileParser.call(
        dependency_files: fetcher.files,
        source: source,
        package_manager: package_manager
      )
      expect(actual_deps).to include(dependency)
    end
  end

  context DependabotServices::FileUpdater do
    let(:files) { fetcher.files }

    it "returns file updater" do
      requirement = dependency.requirements.first
      updated_dep = Dependabot::Dependency.new(
        name: dependency.name,
        package_manager: dependency.package_manager,
        previous_requirements: [requirement],
        previous_version: dependency.version,
        version: "2.2.1",
        requirements: [requirement.merge({ requirement: "~> 2.2.1" })]
      )
      expect_any_instance_of(Dependabot::Bundler::FileUpdater).to receive(:updated_dependency_files)

      DependabotServices::FileUpdater.call(dependencies: [updated_dep], dependency_files: fetcher.files)
    end
  end
end
