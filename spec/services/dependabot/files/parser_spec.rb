# frozen_string_literal: true

describe Dependabot::Files::Parser, epic: :services, feature: :dependabot do
  include_context "with dependabot helper"

  let(:parser) { instance_double("Dependabot::Bundler::FileParser", parse: nil) }
  let(:config_entry) { updates_config.first }
  let(:credentials) { [*Dependabot::Credentials.call(nil), *registries.values] }

  let(:args) do
    {
      dependency_files: fetcher.files,
      source: source,
      repo_contents_path: nil
    }
  end

  before do
    allow(Dependabot::FileParsers).to receive(:for_package_manager)
      .with("bundler")
      .and_return(Dependabot::Bundler::FileParser)
    allow(Dependabot::Bundler::FileParser).to receive(:new) { parser }
  end

  it "parses dependecy files", :aggregate_failures do
    described_class.call(config_entry: config_entry, credentials: credentials, **args)

    expect(Dependabot::Bundler::FileParser).to have_received(:new).with(
      credentials: credentials,
      reject_external_code: config_entry[:reject_external_code],
      options: config_entry[:updater_options],
      **args
    )
    expect(parser).to have_received(:parse)
  end
end
