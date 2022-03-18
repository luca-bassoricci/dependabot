# frozen_string_literal: true

describe Dependabot::Files::Parser, epic: :services, feature: :dependabot do
  include_context "with webmock"
  include_context "with dependabot helper"

  let(:parser) { instance_double("Dependabot::Bundler::FileParser") }
  let(:config_entry) { updates_config.first }

  let(:args) do
    {
      dependency_files: fetcher.files,
      source: source,
      repo_contents_path: nil
    }
  end

  before do
    stub_gitlab

    allow(Dependabot::Bundler::FileParser).to receive(:new) { parser }
    allow(parser).to receive(:parse)
  end

  it "parses dependecy files", :aggregate_failures do
    described_class.call(config_entry: config_entry, registries: registries.values, **args)

    expect(Dependabot::Bundler::FileParser).to have_received(:new).with(
      credentials: [*Dependabot::Credentials.call, *registries.values],
      reject_external_code: config_entry[:reject_external_code],
      **args
    )
    expect(parser).to have_received(:parse)
  end
end
