# frozen_string_literal: true

describe DependabotServices::MergeRequestCreator do
  include_context "webmock"

  let(:package_manager) { "bundler" }
  let(:fetcher) { DependabotServices::FileFetcher.call(source: source, package_manager: package_manager) }
  let(:dep) do
    DependabotServices::FileParser
      .call(dependency_files: fetcher.files, source: source, package_manager: package_manager)
      .select(&:top_level?).first
  end
  let(:updated_dependencies) do
    requirement = dep.requirements.first
    updated_dep = Dependabot::Dependency.new(
      name: dep.name,
      package_manager: dep.package_manager,
      previous_requirements: [requirement],
      previous_version: dep.version,
      version: "2.2.1",
      requirements: [requirement.merge({ requirement: "~> 2.2.1" })]
    )
    [updated_dep]
  end
  let(:updated_files) do
    [
      Dependabot::DependencyFile.new(
        name: "Gemfile",
        directory: "./",
        content: ""
      ),
      Dependabot::DependencyFile.new(
        name: "Gemfile.lock",
        directory: "./",
        content: ""
      )
    ]
  end

  before do
    stub_gitlab

    allow(DependabotServices::UpdateChecker).to receive(:call).and_return(updated_dependencies)
    allow(DependabotServices::FileUpdater).to receive(:call).and_return(updated_files)
  end

  it "creates merge request" do
    expect_any_instance_of(Dependabot::PullRequestCreator).to receive(:create).and_return("mr")

    mr = DependabotServices::MergeRequestCreator.call(
      source: source,
      fetcher: fetcher,
      dependency: dep
    )

    expect(mr).to eq("mr")
  end
end
