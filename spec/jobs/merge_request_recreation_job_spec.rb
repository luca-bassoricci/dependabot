# frozen_string_literal: true

describe MergeRequestRecreationJob, epic: :jobs do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  let(:args) { ["args", 1] }

  before do
    allow(Dependabot::MergeRequestRecreator).to receive(:call)
  end

  it "performs enqued job" do
    perform_enqueued_jobs { job.perform_later(*args) }

    expect(Dependabot::MergeRequestRecreator).to have_received(:call).with(*args)
  end
end
