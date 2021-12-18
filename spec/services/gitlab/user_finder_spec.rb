# frozen_string_literal: true

describe Gitlab::UserFinder, epic: :services, feature: :gitlab do
  subject(:user_finder_return) { described_class.call(usernames) }

  let(:gitlab) { instance_double("Gitlab::Client", user_search: [user1, user2]) }
  let(:user1) { Gitlab::ObjectifiedHash.new(id: 1, username: "test") }
  let(:user2) { Gitlab::ObjectifiedHash.new(id: 2, username: "test2") }

  before do
    allow(Gitlab::Client).to receive(:new) { gitlab }
  end

  context "with existing user" do
    let(:usernames) { %w[test] }

    it "returns array with ids" do
      aggregate_failures do
        expect(user_finder_return).to eq([1])
        expect(gitlab).to have_received(:user_search).with("test")
      end
    end
  end

  context "with non existing user" do
    let(:usernames) { %w[non-existing] }

    it "returns nil" do
      expect(user_finder_return).to be_nil
    end
  end
end
