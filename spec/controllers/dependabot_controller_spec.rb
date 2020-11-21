# frozen_string_literal: true

describe DependabotController do
  include_context "rack_test"

  before do
    allow(Sidekiq::Cron::Job).to receive(:all).and_return([])
  end

  it "return list of jobs" do
    get("/")

    expect(last_response.status).to eq(200)
    expect(Sidekiq::Cron::Job).to have_received(:all)
  end
end
