# frozen_string_literal: true

# :reek:MissingSafeMethod

module Update
  # Dependency update run
  #
  # @!attribute created_at
  #   @return [DateTime]
  # @!attribute updated_at
  #   @return [DateTime]
  # @!attribute job
  #   @return [Update::Job]
  # @!attribute log_entries
  #   @return [Array<LogEntry>]
  # @!attribute failures
  #   @return [Array<Failure>]
  class Run
    include Mongoid::Document
    include Mongoid::Timestamps

    has_many :log_entries, class_name: "Update::LogEntry"
    has_many :failures, class_name: "Update::Failure"

    belongs_to :job, class_name: "Update::Job"

    # Persist log entries
    #
    # @param [Array<Hash>] logs
    # @return [void]
    def save_log_entries!(logs)
      LogEntry.create!(logs.map { |entry| { **entry, run: self } })
    end

    # Persist job errors
    #
    # @param [Array<Hash>] errors
    # @return [void]
    def save_errors!(errors)
      Failure.create!(errors.map { |entry| { **entry, run: self } })
    end
  end
end
