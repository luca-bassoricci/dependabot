# frozen_string_literal: true

describe Configuration do
  context Configuration::Parser do
    let(:expected_config) do
      {
        "bundler" => {
          directory: "/",
          branch: "develop",
          milestone: 4,
          assignees: ["andrcuns"],
          reviewers: ["andrcuns"],
          custom_labels: ["dependency"],
          cron: "00 02 * * sun Europe/Riga",
          branch_name_separator: "-",
          branch_name_prefix: "dependabot",
          commit_message_options: {
            prefix: "dep",
            prefix_development: "bundler-dev",
            include_scope: "scope"
          }
        }
      }
    end

    it "returns parsed configuration" do
      expect(Configuration::Parser.call(File.read("spec/fixture/dependabot.yml"))).to eq(expected_config)
    end
  end

  context Configuration::Schedule do
    it "parses daily schedule configuration" do
      expect(Configuration::Schedule.call(interval: "daily", day: "sunday", time: "2:00")).to eq("00 2 * * * UTC")
    end

    it "parses monthly schedule configuration" do
      expect(Configuration::Schedule.call(interval: "monthly", day: "sunday", time: "2:00")).to eq("00 2 1 * * UTC")
    end
  end
end
