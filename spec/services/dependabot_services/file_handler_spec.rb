# frozen_string_literal: true

describe "File handlers" do
  include_context "webmock"

  before do
    stub_gitlab
  end

  context DependabotServices::FileFetcher do
    it "returns file fetcher" do
      expect(DependabotServices::FileFetcher.call(source)).to be_an_instance_of(Dependabot::Bundler::FileFetcher)
    end
  end

  context DependabotServices::FileParser do
    it "returns file parser" do
      files = DependabotServices::FileFetcher.call(source).files

      expect(DependabotServices::FileParser.call(dependency_files: files, source: source)).to be_an_instance_of(
        Dependabot::Bundler::FileParser
      )
    end
  end

  context DependabotServices::FileUpdater do
    let(:files) { DependabotServices::FileFetcher.call(source).files }
    let(:dep) do
      DependabotServices::FileParser.call(dependency_files: files, source: source).parse.select(&:top_level?).first
    end

    it "returns file updater" do
      requirement = dep.requirements.first
      updated_dep = Dependabot::Dependency.new(
        name: dep.name,
        package_manager: dep.package_manager,
        previous_requirements: [requirement],
        previous_version: dep.version,
        version: "2.2.1",
        requirements: [requirement.merge({ requirement: "~> 2.2.1" })]
      )
      expect(DependabotServices::FileUpdater.call(dependencies: [updated_dep], dependency_files: files)).to(
        be_an_instance_of(Dependabot::Bundler::FileUpdater)
      )
    end
  end
end
