# frozen_string_literal: true

describe Gitlab::ConfigFetcher do
  include_context "dependabot"

  let(:gitlab) { double("Gitlab") }
  let(:repo) { "test-repo" }
  let(:project) { OpenStruct.new(default_branch: "master") }

  before do
    allow(Gitlab).to receive(:client).and_return(gitlab)
  end

  it "fetches config from gitlab" do
    expect(gitlab).to receive(:project).with(repo).and_return(project)
    expect(gitlab).to receive(:file_contents)
      .with(repo, ".gitlab/dependabot.yml", "master")
      .and_return(raw_config)

    expect(Gitlab::ConfigFetcher.call(repo)).to eq(raw_config)
  end
end
