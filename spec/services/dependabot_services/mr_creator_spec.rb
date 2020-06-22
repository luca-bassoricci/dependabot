# frozen_string_literal: true

describe DependabotServices::MergeRequestCreator do
  include_context "webmock"

  let(:fetcher) { DependabotServices::FileFetcher.call(source) }
  let(:dep) do
    DependabotServices::FileParser
      .call(dependency_files: fetcher.files, source: source).parse
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
        content: <<~TXT
          # frozen_string_literal: true
          source "https://rubygems.org"
          ruby "~> 2.6"
          gem "config", "~> 2.2.1"
        TXT
      ),
      Dependabot::DependencyFile.new(
        name: "Gemfile.lock",
        directory: "./",
        content: <<~TXT
          GEM
            remote: https://rubygems.org/
            specs:
              concurrent-ruby (1.1.6)
              config (2.2.1)
                deep_merge (~> 1.2, >= 1.2.1)
                dry-validation (~> 1.0, >= 1.0.0)
              deep_merge (1.2.1)
              dry-configurable (0.11.6)
                concurrent-ruby (~> 1.0)
                dry-core (~> 0.4, >= 0.4.7)
                dry-equalizer (~> 0.2)
              dry-container (0.7.2)
                concurrent-ruby (~> 1.0)
                dry-configurable (~> 0.1, >= 0.1.3)
              dry-core (0.4.9)
                concurrent-ruby (~> 1.0)
              dry-equalizer (0.3.0)
              dry-inflector (0.2.0)
              dry-initializer (3.0.3)
              dry-logic (1.0.6)
                concurrent-ruby (~> 1.0)
                dry-core (~> 0.2)
                dry-equalizer (~> 0.2)
              dry-schema (1.5.1)
                concurrent-ruby (~> 1.0)
                dry-configurable (~> 0.8, >= 0.8.3)
                dry-core (~> 0.4)
                dry-equalizer (~> 0.2)
                dry-initializer (~> 3.0)
                dry-logic (~> 1.0)
                dry-types (~> 1.4)
              dry-types (1.4.0)
                concurrent-ruby (~> 1.0)
                dry-container (~> 0.3)
                dry-core (~> 0.4, >= 0.4.4)
                dry-equalizer (~> 0.3)
                dry-inflector (~> 0.1, >= 0.1.2)
                dry-logic (~> 1.0, >= 1.0.2)
              dry-validation (1.5.1)
                concurrent-ruby (~> 1.0)
                dry-container (~> 0.7, >= 0.7.1)
                dry-core (~> 0.4)
                dry-equalizer (~> 0.2)
                dry-initializer (~> 3.0)
                dry-schema (~> 1.5)

          PLATFORMS
            ruby

          DEPENDENCIES
            config (~> 2.2.1)

          RUBY VERSION
             ruby 2.6.5p114

          BUNDLED WITH
             2.1.4
        TXT
      )
    ]
  end

  before do
    stub_gitlab
  end

  it "returns merge request creator" do
    mr_creator = DependabotServices::MergeRequestCreator.call(
      source: source,
      base_commit: fetcher.commit,
      dependencies: updated_dependencies,
      files: updated_files
    )
    expect(mr_creator).to be_an_instance_of(Dependabot::PullRequestCreator)
  end
end
