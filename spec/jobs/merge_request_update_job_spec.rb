# frozen_string_literal: true

describe MergeRequestUpdateJob, epic: :jobs do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  let(:project_name) { "project" }
  let(:mr_iid) { 1 }

  before do
    allow(Dependabot::MergeRequestUpdater).to receive(:call)
  end

  it "performs enqued job" do
    perform_enqueued_jobs { job.perform_later(project_name, mr_iid) }

    expect(Dependabot::MergeRequestUpdater).to have_received(:call).with(
      project_name: project_name,
      mr_iid: mr_iid,
      recreate: false
    )
  end
end
