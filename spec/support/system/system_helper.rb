# frozen_string_literal: true

require_relative "mocks"
require_relative "smocker"
require_relative "../api_helper"

RSpec.shared_context "with system helper" do
  include_context "with api helper"

  include Support::Mocks::Gitlab

  let(:mock) { Support::Smocker.new }

  before do
    driven_by(:rack_test)

    mock.reset
    mock.add(*mock_definitions)
  end

  def expect_all_mocks_called
    resp = mock.verify
    verified = resp.dig(:mocks, :verified)
    unused = resp.dig(:mocks, :unused)
    failures = resp.dig(:history, :failures)

    aggregate_failures do
      expect(verified).to eq(true), "Expected all mocks to be verified"
      expect(unused).to eq(nil), "Expected no unused mocks: #{JSON.pretty_generate(unused)}"
      expect(failures).to eq(nil), "Expected to not have failures: #{JSON.pretty_generate(failures)}"
    end
  end
end
