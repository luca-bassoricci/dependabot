# frozen_string_literal: true

# Job execution log entry
#
# @!attribute timestamp
#   @return [DateTime]
# @!attribute level
#   @return [String]
# @!attribute message
#   @return [String]
#
class LogEntry
  include Mongoid::Document

  field :timestamp, type: DateTime
  field :level, type: String
  field :message, type: String

  belongs_to :update_job
end
