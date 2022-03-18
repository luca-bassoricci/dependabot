# frozen_string_literal: true

class Project
  include Mongoid::Document

  unalias_attribute :id

  field :name, type: String
  field :id, type: Integer
  field :forked_from_id, type: Integer
  field :forked_from_name, type: String
  field :webhook_id, type: Integer
  field :web_url, type: String

  has_many :merge_requests, dependent: :destroy
  has_many :update_jobs, dependent: :destroy

  embeds_one :configuration

  # Return projects hash representation
  #
  # @return [Hash]
  def to_hash
    {
      id: id,
      name: name,
      forked_from_id: forked_from_id,
      forked_from_name: forked_from_name,
      webhook_id: webhook_id,
      web_url: web_url,
      config: configuration.updates
    }
  end
end
