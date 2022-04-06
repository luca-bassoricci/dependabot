# frozen_string_literal: true

describe Dependabot::Files::Fetcher, epic: :services, feature: :dependabot do
  subject do
    described_class.call(
      project_name: project.name,
      config_entry: project.configuration.entry(package_ecosystem: "bundler"),
      repo_contents_path: nil,
      registries: project.configuration.registries.values
    )
  end

  let(:project) { build(:project) }

  it { is_expected.to be_an_instance_of(Dependabot::Bundler::FileFetcher) }
end
