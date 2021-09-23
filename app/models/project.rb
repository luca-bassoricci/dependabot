# frozen_string_literal: true

class Project
  include Mongoid::Document

  unalias_attribute :id

  field :name, type: String
  field :id, type: Integer
  field :forked_from_id, type: Integer
  field :config, type: Array, default: []
  field :webhook_id, type: Integer
  field :web_url, type: String

  has_many :merge_requests, dependent: :destroy
  has_many :update_jobs, dependent: :destroy

  # Symbolize all config keys when loading from database
  #
  # @return [Array<Symbol, Object>]
  def symbolized_config
    config.map(&:deep_symbolize_keys)
  end
end
