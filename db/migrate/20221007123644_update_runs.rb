# frozen_string_literal: true

class UpdateRuns < Mongoid::Migration
  def self.up
    Update::Job.all.unset(:failures, :log_entries, :last_executed)
    Update::Run.create_indexes
  end

  def self.down
    Update::Run.remove_indexes
  end
end
