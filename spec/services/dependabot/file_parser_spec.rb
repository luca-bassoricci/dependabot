# frozen_string_literal: true

describe Dependabot::FileParser, epic: :services, feature: :dependabot do
  include_context "with webmock"
  include_context "with dependabot helper"

  let(:parser) { instance_double("Dependabot::Bundler::FileParser") }
  let(:args) do
    {
      dependency_files: fetcher.files,
      source: source,
      repo_contents_path: nil,
      reject_external_code: true
    }
  end

  before do
    stub_gitlab

    allow(Dependabot::Bundler::FileParser).to receive(:new) { parser }
    allow(parser).to receive(:parse)
  end

  it "parses dependecy files" do
    described_class.call(package_manager: package_manager, **args)

    aggregate_failures do
      expect(Dependabot::Bundler::FileParser).to have_received(:new)
        .with(credentials: Dependabot::Credentials.call, **args)
      expect(parser).to have_received(:parse)
    end
  end
end
