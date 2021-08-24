# frozen_string_literal: true

class UpdateJob
  include Mongoid::Document

  field :package_ecosystem, type: String
  field :directory, type: String
  field :cron, type: String
  field :last_executed, type: DateTime
  field :run_errors, type: Array, default: []

  belongs_to :project
end
