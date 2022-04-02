# frozen_string_literal: true

require "rake"

RSpec.shared_context "with rake helper" do
  subject(:task) { Rake::Task[task_name] }

  let(:task_name) { self.class.description }

  before(:all) do
    Rails.application.load_tasks
  end

  after do
    task.reenable
  end
end
