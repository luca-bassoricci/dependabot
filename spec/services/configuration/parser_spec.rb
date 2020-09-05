# frozen_string_literal: true

describe Configuration::Parser do
  include_context "dependabot"

  let(:allow_conf) { [{ dependency_type: "direct" }] }
  let(:ignore_conf) { [{ dependency_name: "rspec", versions: ["3.x", "4.x"] }] }

  subject { described_class.call(File.read("spec/gitlab_mock/responses/gitlab/dependabot.yml")) }

  it "returns parsed configuration" do
    expect(subject).to eq(dependabot_config)
  end
end
