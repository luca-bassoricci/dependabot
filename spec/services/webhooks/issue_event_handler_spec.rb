# frozen_string_literal: true

describe Webhooks::IssueEventHandler, :integration, epic: :services, feature: :webhooks do
  subject(:issue_handler) { described_class.call(project_name: project.name, issue_iid: vulnerability_issue.iid) }

  let(:status) { "opened" }
  let(:project) { create(:project) }
  let(:vulnerability_issue) { create(:vulnerability_issue, project: project, status: status) }

  context "with existing open vulnerability issue" do
    it "updates status to closed" do
      expect(issue_handler).to eq(true)
      expect(vulnerability_issue.reload.status).to eq("closed")
    end
  end

  context "without existing vulnerability issue" do
    let(:status) { "closed" }

    it "skips status update" do
      expect(issue_handler).to be_nil
    end
  end
end
