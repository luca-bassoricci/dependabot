# frozen_string_literal: true

class Configuration
  include Mongoid::Document

  field :updates, type: Array, default: []
  field :registries, type: Registries, default: Registries.new({})

  embedded_in :project

  # Get single config entry
  #
  # @param [Hash] find_by
  # @return [Hash]
  def entry(**find_by)
    entries(find_by).first
  end

  # Get config entries and symbolize keys
  #
  # @param [Hash] find_by
  # @return [Hash]
  def entries(**find_by)
    entries = updates.select { |conf| find_by.all? { |key, value| conf[key] == value } }

    entries.map do |entry|
      entry.to_h.deep_symbolize_keys
    end
  end

  # Allowd registries for config entry
  #
  # @param [Hash] find_by
  # @return [Array<Hash>]
  def allowed_registries(**find_by)
    config_entry = entry(find_by)
    return unless config_entry

    allowed_registries = config_entry[:registries]
    return registries.values if allowed_registries == "*"

    registries.slice(*allowed_registries).values
  end

  # Object comparator
  # @param [Config] other
  # @return [Booelan]
  def ==(other)
    self.class == other.class && updates == other.updates && registries == other.registries
  end
end
