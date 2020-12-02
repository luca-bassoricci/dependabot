# frozen_string_literal: true

describe Dependabot::FileParser do
  include_context "with webmock"
  include_context "with dependabot helper"

  let(:parser) { instance_double("Dependabot::Bundler::FileParser") }
  let(:args) do
    {
      dependency_files: fetcher.files,
      source: source
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
      expect(Dependabot::Bundler::FileParser).to have_received(:new).with(credentials: Credentials.fetch, **args)
      expect(parser).to have_received(:parse)
    end
  end
end
