# frozen_string_literal: true

describe Gitlab::ClientWithRetry, epic: :services, feature: :gitlab do
  subject(:client) { described_class.new }

  let(:gitlab) { instance_double("Gitlab::client") }

  before do
    allow(Gitlab).to receive(:client) { gitlab }
    allow(gitlab).to receive(:get_file).and_raise(
      Gitlab::Error::BadGateway.new(
        OpenStruct.new(
          code: 500,
          parsed_response: "Failure",
          request: OpenStruct.new(base_uri: "gitlab.com", path: "/get_file")
        )
      )
    )
  end

  it "retries gitlab request" do
    aggregate_failures do
      expect { client.get_file }.to raise_error(Gitlab::Error::BadGateway)
      expect(gitlab).to have_received(:get_file).exactly(3).times
    end
  end
end
