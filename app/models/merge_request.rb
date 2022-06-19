# frozen_string_literal: true

class MergeRequest
  include Mongoid::Document

  unalias_attribute :id

  field :id, type: Integer
  field :iid, type: Integer
  field :package_ecosystem, type: String
  field :directory, type: String
  field :state, type: String
  field :auto_merge, type: Boolean
  field :squash, type: Boolean
  field :update_from, type: String
  field :update_to, type: String
  field :main_dependency, type: String
  field :branch, type: String
  field :target_branch, type: String
  field :target_project_id, type: String
  field :commit_message, type: String

  belongs_to :project

  # Set merge request status to closed
  #
  # @return [void]
  def close
    update_attributes!(state: "closed")
  end
end
