# frozen_string_literal: true

class MergeRequest
  include Mongoid::Document

  field :iid, type: Integer
  field :package_manager, type: String
  field :state, type: String
  field :auto_merge, type: Boolean
  field :dependencies, type: String

  belongs_to :project
end
