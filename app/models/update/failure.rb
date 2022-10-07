# frozen_string_literal: true

module Update
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

    belongs_to :run, class_name: "Update::Run"
  end
end
