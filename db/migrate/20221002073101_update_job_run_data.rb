# frozen_string_literal: true

class UpdateJobRunData < Mongoid::Migration
  def self.up
    UpdateJob.all.each do |job|
      job.atomically do
        job.unset(:run_errors)
        job.unset(:run_log)
      end
    end
  end

  def self.down
    UpdateJob.all.each do |job|
      job.run_errors = []
      job.run_log = []

      job.save!
    end
  end
end
