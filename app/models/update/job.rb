# frozen_string_literal: true

module Update
  # Dependency update job
  #
  # @!attribute package_ecosystem
  #   @return [String]
  # @!attribute directory
  #   @return [String]
  # @!attribute cron
  #   @return [String]
  # @!attribute project
  #   @return [Project]
  # @!attribute runs
  #   @return [Array<Update::Run>]
  class Job
    include Mongoid::Document

    field :package_ecosystem, type: String
    field :directory, type: String
    field :cron, type: String

    belongs_to :project

    has_many :runs, class_name: "Update::Run", dependent: :destroy

    # Last run of the job
    #
    # @return [DateTime]
    def last_executed
      runs.last&.created_at
    end
  end
end
