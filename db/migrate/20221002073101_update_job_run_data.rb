# frozen_string_literal: true

class UpdateJobRunData < Mongoid::Migration
  def self.up
    UpdateJob.all.unset(:run_errors)
    UpdateJob.all.unset(:run_log)
  end

  def self.down; end
end
