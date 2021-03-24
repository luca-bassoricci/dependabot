# frozen_string_literal: true

describe Webhooks::CommentEventHandler, epic: :services, feature: :webhooks do
  include ActiveJob::TestHelper

  let(:project) { "dependabot/test" }
  let(:mr_id) { 1 }
  let(:response) { "mr" }

  let(:job) { MergeRequestRecreationJob }

  before do
    allow(Gitlab::MergeRequestRebaser).to receive(:call) { response }
  end

  it "skips invalid commands" do
    aggregate_failures do
      expect(described_class.call("test comment", project, mr_id)).to be_nil
      expect(Gitlab::MergeRequestRebaser).not_to have_received(:call)
    end
  end

  it "rebases merge request" do
    aggregate_failures do
      expect(described_class.call("$dependabot rebase", project, mr_id)).to eq(response)
      expect(Gitlab::MergeRequestRebaser).to have_received(:call).with(project, mr_id)
    end
  end

  it "recreates merge request" do
    ActiveJob::Base.queue_adapter = :test
    expect { described_class.call("$dependabot recreate", project, mr_id) }.to have_enqueued_job(job)
      .with(project, mr_id)
      .on_queue("default")
  end
end
