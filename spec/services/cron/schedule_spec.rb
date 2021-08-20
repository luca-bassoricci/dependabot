# frozen_string_literal: true

describe Cron::Schedule, epic: :services, feature: :configuration do
  subject(:cron) { described_class }

  let(:time) { "2:00" }
  let(:day) { "sunday" }
  let(:entry_a) { "a-bundler-/" }
  let(:entry_b) { "b-docker-/" }

  it "parses daily schedule configuration" do
    expect(cron.call(entry: entry_a, interval: "daily", day: day, time: time)).to eq("00 2 * * * UTC")
  end

  it "parses monthly schedule configuration" do
    expect(cron.call(entry: entry_a, interval: "monthly", day: day, time: time)).to eq("00 2 1 * * UTC")
  end

  it "generates random cron hour based on project name" do
    cron_a = cron.call(entry: entry_a, interval: "daily", day: day)
    cron_b = cron.call(entry: entry_b, interval: "daily", day: day)

    cron_a_dup = cron.call(entry: entry_a, interval: "daily", day: day)

    expect(cron_a).not_to eq(cron_b)
    expect(cron_a).to eq(cron_a_dup)
  end

  it "generates random cron day based on project name" do
    cron_a = cron.call(entry: entry_a, interval: "weekly", time: "2:00")
    cron_b = cron.call(entry: entry_b, interval: "weekly", time: "2:00")

    cron_a_dup = cron.call(entry: entry_a, interval: "weekly", time: "2:00")

    expect(cron_a).not_to eq(cron_b)
    expect(cron_a).to eq(cron_a_dup)
  end
end
