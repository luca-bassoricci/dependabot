# frozen_string_literal: true

class MergeRequest
  include Mongoid::Document

  field :id, type: Integer
  field :library, type: String
  field :version, type: String
  field :open, type: Boolean
  field :auto_merge, type: Boolean
  field :has_conflicts, type: Boolean

  belongs_to :project
end
