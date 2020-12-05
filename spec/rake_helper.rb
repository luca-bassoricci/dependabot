# frozen_string_literal: true

require "rake"

RSpec.shared_context "with rake helper" do
  subject(:task) { Rake::Task[task_name] }

  let(:task_name) { self.class.description }

  before(:all) do # rubocop:disable RSpec/BeforeAfterAll
    Rails.application.load_tasks
  end
end
