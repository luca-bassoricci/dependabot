# frozen_string_literal: true

describe Dependabot::Files::Fetcher, epic: :services, feature: :dependabot do
  subject do
    described_class.call(
      project_name: repo,
      config_entry: updates_config.first,
      repo_contents_path: nil,
      registries: registries.values
    )
  end

  include_context "with webmock"
  include_context "with dependabot helper"

  before do
    stub_gitlab
  end

  it { is_expected.to be_an_instance_of(Dependabot::Bundler::FileFetcher) }
end
