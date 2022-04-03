# frozen_string_literal: true

require_relative "mocks"
require_relative "smocker"
require_relative "../api_helper"

RSpec.shared_context "with system helper" do
  include_context "with api helper"

  include Support::Mocks

  let(:mock) { Support::Smocker.new }

  before do
    driven_by(:rack_test)

    mock.reset
  end

  def expect_all_mocks_called
    resp = mock.verify
    aggregate_failures do
      expect(resp.dig(:mocks, :verified)).to eq(true), "Expected all mocks to be verified"
      expect(resp.dig(:mocks, :unused)).to eq(nil)
      expect(resp.dig(:history, :failures)).to eq(nil)
    end
  end
end
