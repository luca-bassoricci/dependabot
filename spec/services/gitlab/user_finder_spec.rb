# frozen_string_literal: true

describe Gitlab::UserFinder do
  subject(:user_finder_return) { described_class.call(usernames) }

  let(:gitlab) { instance_double("Gitlab::Client", user_search: [user]) }
  let(:user) { OpenStruct.new(id: 1) }
  let(:usernames) { %w[test test2] }

  before do
    allow(Gitlab::Client).to receive(:new) { gitlab }
  end

  it "returns array with ids" do
    expect(user_finder_return).to eq([1, 1])
    aggregate_failures do
      usernames.each { |username| expect(gitlab).to have_received(:user_search).with(username) }
    end
  end
end
