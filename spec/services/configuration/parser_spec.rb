# frozen_string_literal: true

describe Configuration::Parser do
  include_context "dependabot"

  let(:allow_conf) { [{ dependency_type: "direct" }] }
  let(:ignore_conf) { [{ dependency_name: "rspec", versions: ["3.x", "4.x"] }] }

  let(:invalid_config) do
    <<~YAML
      version: 2
      updates:
        - package-ecosystem: bundler
          schedule:
            time: "19:00"
          milestone: 4
          ignore:
            - versions: ["3.x", "4.x"]
    YAML
  end
  let(:invalid_config_error) do
    <<~ERR.strip
      0.directory: is missing
      0.schedule.interval: is missing
      0.ignore.0.dependency-name: is missing
      0.milestone: must be a string
    ERR
  end

  subject { described_class }

  it "returns parsed configuration" do
    expect(subject.call(File.read("spec/gitlab_mock/responses/gitlab/dependabot.yml"))).to eq(dependabot_config)
  end

  it "throws invalid configuration error" do
    expect { subject.call(invalid_config) }.to raise_error(
      Configuration::InvalidConfigurationError, /#{invalid_config_error}/
    )
  end
end
