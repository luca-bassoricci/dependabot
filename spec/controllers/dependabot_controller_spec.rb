# frozen_string_literal: true

describe DependabotController do
  include_context "rack_test"

  it "return list of jobs" do
    expect(Sidekiq::Cron::Job).to receive(:all).and_return([])

    get("/")

    expect(last_response.status).to eq(200)
  end
end
