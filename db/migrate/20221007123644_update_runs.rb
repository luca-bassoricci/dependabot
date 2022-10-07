# frozen_string_literal: true

class UpdateRuns < Mongoid::Migration
  def self.up
    Update::Job.all.unset(:failures, :log_entries, :last_executed)
  end

  def self.down; end
end
