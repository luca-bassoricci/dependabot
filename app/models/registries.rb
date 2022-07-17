# frozen_string_literal: true

class Registries
  AUTH_FIELDS = %w[token key password].freeze
  SECRET_PATTERN = /\${{([^{}]+)}}/.freeze

  def initialize(registries)
    @registries = registries
  end

  # @return [Hash]
  attr_reader :registries

  # Return registries matching filter
  #
  # @param [String] filter
  # @return [Array<Hash>]
  def select(filter)
    registries
      .select { |name, _registry| name.match?(filter) }
      .map { |name, registry| registry.map { |key, value| [key, env_value(name, key, value)] }.to_h }
  end

  # Convert object to database compatible form
  #
  # @return [Hash]
  def mongoize
    Registries.update_auth_fields(registries, :encrypt)
  end

  # Object comparator
  # @param [Config] other
  # @return [Booelan]
  def ==(other)
    self.class == other.class && registries == other.registries
  end

  private

  # Fetch value from environment for auth field
  #
  # @param [String] registry_name
  # @param [String] key
  # @param [Object] value
  # @return [Object]
  def env_value(registry_name, key, value)
    return value unless ["username", *AUTH_FIELDS].include?(key) && value.match?(SECRET_PATTERN)

    env_val = value.scan(SECRET_PATTERN).flatten.reduce(value) do |val, env_key|
      val.gsub("${{#{env_key}}}", ENV[env_key] || "")
    end

    if env_val.blank?
      ApplicationHelper.log(:warn, "Detected empty value for '#{key}' in configuration of '#{registry_name}' registry")
    end

    env_val
  end

  class << self
    # Convert object to Config
    #
    # @param [Array<Hash>] object
    # @return [Registries]
    def demongoize(object)
      Registries.new(Registries.update_auth_fields(object, :decrypt))
    end

    # Convert object to database compatible form
    #
    # @param [Hash, Registries] object
    # @return [Hash]
    def mongoize(object)
      case object
      when Hash then Registries.new(object).mongoize
      when Registries then object.mongoize
      else object
      end
    end

    # Convert object supplied as criteria
    #
    # @param [Registries] object
    # @return [Array]
    def evolve(object)
      case object
      when Registries then object.mongoize
      else object
      end
    end

    # Encrypt or decrypt auth fields in registries definition if stored in plain text
    #
    # @param [Hash] registries
    # @param [Symbol] method
    # @return [Hash]
    def update_auth_fields(registries, method)
      registries.deep_dup.transform_values do |registry|
        registry.map do |key, value|
          [
            key,
            AUTH_FIELDS.include?(key) && !value.match?(SECRET_PATTERN) ? EncryptHelper.send(method, value) : value
          ]
        end.to_h
      end
    end
  end
end
