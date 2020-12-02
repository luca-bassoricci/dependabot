# frozen_string_literal: true

describe Dependabot::FileUpdater do
  subject(:file_updater) do
    described_class.call(
      dependencies: updated_dependencies,
      dependency_files: fetcher.files,
      package_manager: package_manager
    )
  end

  include_context "with webmock"
  include_context "with dependabot helper"

  let(:files) { fetcher.files }
  let(:updater) { instance_double("Dependabot::Bundler::FileUpdater") }

  before do
    stub_gitlab

    allow(Dependabot::Bundler::FileUpdater).to receive(:new) { updater }
    allow(updater).to receive(:updated_dependency_files) { updated_dependencies }
  end

  it "fetches dependency updates" do
    expect(file_updater).to eq(updated_dependencies)
    expect(Dependabot::Bundler::FileUpdater).to have_received(:new).with(
      dependencies: updated_dependencies,
      dependency_files: fetcher.files,
      credentials: Credentials.fetch
    )
  end
end
