# frozen_string_literal: true

class JobErrors
  include Mongoid::Document

  field :name, type: String
  field :run_errors, type: Array, default: []
end
