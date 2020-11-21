# frozen_string_literal: true

class Project
  include Mongoid::Document

  field :name, type: String
  field :config, type: Array

  has_many :merge_requests, dependent: :destroy

  # Symbolize all keys when loading from database
  #
  # @return [Array<Symbol, Object>]
  def symbolized_config
    config.map(&:deep_symbolize_keys)
  end
end
