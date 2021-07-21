# frozen_string_literal: true

class MergeRequest
  include Mongoid::Document

  field :iid, type: Integer
  field :package_manager, type: String
  field :directory, type: String
  field :state, type: String
  field :auto_merge, type: Boolean
  field :dependencies, type: String
  field :main_dependency, type: String
  field :branch, type: String

  belongs_to :project
end
