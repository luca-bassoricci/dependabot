# frozen_string_literal: true

class UpdateJobRunData < Mongoid::Migration
  def self.up
    Update::Job.all.unset(:run_errors)
    Update::Job.all.unset(:run_log)
  end

  def self.down; end
end
