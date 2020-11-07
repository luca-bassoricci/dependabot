# frozen_string_literal: true

class Project
  include Mongoid::Document

  field :id, type: Integer
  field :name, type: String
  field :config, type: Array

  has_many :merge_requests
end
