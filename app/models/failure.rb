# frozen_string_literal: true

# Update job failures
#
# @!attribute message
#   @return [String]
# @!attribute backtrace
#   @return [String]
#
class Failure
  include Mongoid::Document

  field :message, type: String
  field :backtrace, type: String

  belongs_to :update_job
end
