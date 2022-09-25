# frozen_string_literal: true

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
#
class UpdateJob
  include Mongoid::Document

  field :package_ecosystem, type: String
  field :directory, type: String
  field :cron, type: String
  field :last_executed, type: DateTime
  field :run_errors, type: Array, default: []

  belongs_to :project
  embeds_many :log_entries

  # Persist log entries
  #
  # @param [Array<Hash>] logs
  # @return [void]
  def save_log_entries(logs)
    logs.map { |entry| LogEntry.new(**entry, update_job: self) }.each(&:save!)
  end
end
