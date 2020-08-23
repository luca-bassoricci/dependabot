# frozen_string_literal: true

describe "File handlers" do
  include_context "webmock"
  include_context "dependabot"

  before do
    stub_gitlab
  end

  context Dependabot::FileFetcher do
    subject { described_class.call(source: source, package_manager: package_manager) }

    it "returns file fetcher" do
      expect(subject).to be_an_instance_of(Dependabot::Bundler::FileFetcher)
    end
  end

  context Dependabot::FileParser do
    subject do
      described_class.call(
        dependency_files: fetcher.files,
        source: source,
        package_manager: package_manager
      )
    end

    it "returns parsed dependencies" do
      expect(subject).to include(dependency)
    end
  end

  context Dependabot::FileUpdater do
    let(:files) { fetcher.files }
    let(:file_updater) { double("file_updater") }

    subject do
      described_class.call(
        dependencies: updated_dependencies,
        dependency_files: fetcher.files,
        package_manager: package_manager
      )
    end

    before do
      allow(Dependabot::Bundler::FileUpdater).to receive(:new) { file_updater }
      allow(file_updater).to receive(:updated_dependency_files) { updated_dependencies }
    end

    it "fetches dependency updates" do
      expect(subject).to eq(updated_dependencies)
      expect(Dependabot::Bundler::FileUpdater).to have_received(:new).with(
        dependencies: updated_dependencies,
        dependency_files: fetcher.files,
        credentials: Credentials.fetch
      )
    end
  end
end
