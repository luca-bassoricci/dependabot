# frozen_string_literal: true

describe "File handlers" do
  include_context "webmock"
  include_context "dependabot"

  before do
    stub_gitlab
  end

  context DependabotServices::FileFetcher do
    it "returns file fetcher" do
      expect(
        DependabotServices::FileFetcher.call(source: source, package_manager: package_manager)
      ).to be_an_instance_of(Dependabot::Bundler::FileFetcher)
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
      expect_any_instance_of(Dependabot::Bundler::FileUpdater).to receive(:updated_dependency_files)

      DependabotServices::FileUpdater.call(dependencies: updated_dependencies, dependency_files: fetcher.files)
    end
  end
end
