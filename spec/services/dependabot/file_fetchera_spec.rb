# frozen_string_literal: true

describe Dependabot::FileFetcher do
  subject { described_class.call(source: source, package_manager: package_manager) }

  include_context "with webmock"
  include_context "with dependabot helper"

  before do
    stub_gitlab
  end

  it { is_expected.to be_an_instance_of(Dependabot::Bundler::FileFetcher) }
end
