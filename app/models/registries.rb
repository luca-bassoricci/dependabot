# frozen_string_literal: true

class Registries
  AUTH_FIELDS = %w[token key password].freeze
  SECRET_PATTERN = /\${{(\S+)}}/.freeze

  def initialize(registries)
    @registries = registries
  end

  delegate :values, :slice, to: :parsed_registries

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

  protected

  # @return [Hash]
  attr_reader :registries

  private

  # Registries hash with evaluated auth fields
  #
  # @return [Hash]
  def parsed_registries
    @parsed_registries ||= registries.map do |name, registry|
      [
        name,
        registry.map { |key, value| [key, env_value(name, key, value)] }.to_h
      ]
    end.to_h
  end

  # Fetch value from environment for auth field
  #
  # @param [String] registry_name
  # @param [String] key
  # @param [Object] value
  # @return [Object]
  def env_value(registry_name, key, value)
    return value unless ["username", *AUTH_FIELDS].include?(key) && value.match?(SECRET_PATTERN)

    env_val = ENV[value.match(SECRET_PATTERN)[1]] || ""
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
