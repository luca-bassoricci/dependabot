# frozen_string_literal: true

# :reek:MissingSafeMethod

# Dependency update job
#
# @!attribute package_ecosystem
#   @return [String]
# @!attribute directory
#   @return [String]
# @!attribute cron
#   @return [String]
# @!attribute last_executed
#   @return [DateTime]
# @!attribute run_errors
#   @return [Array]
# @!attribute project
#   @return [Project]
# @!attribute log_entries
#   @return [Array<LogEntry>]
# @!attribute failures
#   @return [Array<Failure>]
#
class UpdateJob
  include Mongoid::Document

  field :package_ecosystem, type: String
  field :directory, type: String
  field :cron, type: String
  field :last_executed, type: DateTime

  belongs_to :project

  embeds_many :log_entries
  embeds_many :failures

  # Persist log entries
  #
  # @param [Array<Hash>] logs
  # @return [void]
  def save_log_entries!(logs)
    LogEntry.create!(logs.map { |entry| { **entry, update_job: self } })
  end

  # Persist job errors
  #
  # @param [Array<Hash>] errors
  # @return [void]
  def save_errors!(errors)
    Failure.create!(errors.map { |entry| { **entry, update_job: self } })
  end
end
