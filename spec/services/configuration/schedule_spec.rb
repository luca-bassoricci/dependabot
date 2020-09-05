# frozen_string_literal: true

describe Configuration::Schedule do
  subject { described_class }

  it "parses daily schedule configuration" do
    expect(subject.call(interval: "daily", day: "sunday", time: "2:00")).to eq("00 2 * * * UTC")
  end

  it "parses monthly schedule configuration" do
    expect(subject.call(interval: "monthly", day: "sunday", time: "2:00")).to eq("00 2 1 * * UTC")
  end
end
