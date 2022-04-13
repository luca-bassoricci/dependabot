# frozen_string_literal: true

describe Dependabot::Files::Updater, epic: :services, feature: :dependabot do
  subject(:file_updater) do
    described_class.call(
      dependencies: updated_dependencies,
      dependency_files: fetcher.files,
      repo_contents_path: nil,
      credentials: credentials,
      config_entry: config_entry
    )
  end

  include_context "with dependabot helper"

  let(:updater) { instance_double("Dependabot::Bundler::FileUpdater") }
  let(:credentials) { Dependabot::Credentials.call }
  let(:files) { fetcher.files }
  let(:config_entry) { updates_config.first }

  before do
    allow(Dependabot::Bundler::FileUpdater).to receive(:new) { updater }
    allow(updater).to receive(:updated_dependency_files) { updated_dependencies }
  end

  it "fetches dependency updates" do
    expect(file_updater).to eq(updated_dependencies)
    expect(Dependabot::Bundler::FileUpdater).to have_received(:new).with(
      dependencies: updated_dependencies,
      dependency_files: fetcher.files,
      credentials: credentials,
      repo_contents_path: nil,
      options: config_entry[:updater_options]
    )
  end
end
