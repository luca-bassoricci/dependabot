# frozen_string_literal: true

class Project
  include Mongoid::Document

  unalias_attribute :id

  field :name, type: String
  field :id, type: Integer
  field :forked_from_id, type: Integer
  field :config, type: Config, default: Config.new([])
  field :webhook_id, type: Integer
  field :web_url, type: String

  has_many :merge_requests, dependent: :destroy
  has_many :update_jobs, dependent: :destroy

  # Convert project to hash with auth fields removed in registries
  #
  # @return [Hash]
  def sanitized_hash
    {
      id: id,
      name: name,
      forked_from_id: forked_from_id,
      webhook_id: webhook_id,
      web_url: web_url,
      config: config.sanitize
    }
  end
end
