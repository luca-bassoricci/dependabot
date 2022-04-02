# frozen_string_literal: true

require_relative "api_helper"
require_relative "smocker"
require_relative "mocks"

RSpec.shared_context "with system helper" do
  include_context "with api helper"

  include Support::Mocks

  let(:mock) { Support::Smocker.new }

  before do |example|
    driven_by(:rack_test) if example.metadata[:system]

    mock.reset
  end

  def verify_mocks
    resp = mock.verify
    aggregate_failures do
      expect(resp.dig(:mocks, :verified)).to eq(true), "Expected all mocks to be verified"
      expect(resp.dig(:mocks, :all_used)).to eq(true), "Expected all mocks to be used"
      expect(resp.dig(:history, :failures)).to eq(nil), "Expected to not have any mocked call errors"
    end
  end

  def mock_project_create
    mock.add(project_mock)
    mock.add(hook_mock)
    mock.add(set_hook_mock)
    mock.add(config_check_mock)
    mock.add(config_file_mock)
  end
end
