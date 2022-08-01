# frozen_string_literal: true

describe Project, :integration, epic: :models do
  let(:project) { create(:project, gitlab_access_token: access_token) }
  let(:access_token) { "test-token" }

  let(:persisted_project) { described_class.find_by(name: project.name) }

  it "persists gitlab access token" do
    expect(persisted_project.gitlab_access_token).to eq(access_token)
  end
end
