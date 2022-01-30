# frozen_string_literal: true

class Config
  AUTH_FIELDS = %w[token key password].freeze

  def initialize(config_array)
    @config_array = config_array
  end

  delegate :select, :map, :first, :last, :empty?, :find, to: :config_array

  # @return [Array<Hash>]
  attr_reader :config_array

  # Get single config entry
  #
  # @param [Hash] find_by
  # @return [Hash]
  def entry(**find_by)
    config_array.find do |conf|
      find_by.all? { |key, value| conf[key] == value }
    end
  end

  # Convert object to database compatible form
  #
  # @return [Array<Hash>]
  def mongoize
    Config.update_auth_fields(config_array, :encrypt)
  end

  # Remove auth fields from registries
  #
  # @return [Array<Hash>]
  def sanitize
    config_array.map do |entry|
      next entry unless entry[:registries]

      entry.merge({ registries: entry[:registries].map { |reg| reg.except(*AUTH_FIELDS) } })
    end
  end

  # Object comparator
  # @param [Config] other
  # @return [Booelan]
  def ==(other)
    self.class == other.class && config_array == other.config_array
  end

  class << self
    # Convert object to Config
    #
    # @param [Array<Hash>] object
    # @return [Registries]
    def demongoize(object)
      Config.new(Config.update_auth_fields(object, :decrypt))
    end

    # Convert object to database compatible form
    #
    # @param [Array, Config] object
    # @return [Array]
    def mongoize(object)
      case object
      when Array then Config.new(object).mongoize
      when Config then object.mongoize
      else object
      end
    end

    # Convert object supplied as criteria
    #
    # @param [Registries] object
    # @return [Array]
    def evolve(object)
      case object
      when Config then object.mongoize
      else object
      end
    end

    # Encrypt or decrypt auth fields in registries definition
    #
    # @param [Array<Hash>] config
    # @param [Symbol] method
    # @return [Array<Hash>]
    # :reek:NestedIterators
    def update_auth_fields(config, method)
      config.map do |entry|
        next entry unless entry[:registries]

        entry.merge({
          registries: entry[:registries].map do |registry|
            registry.each_with_object({}) do |(key, value), obj|
              obj[key] = AUTH_FIELDS.include?(key) ? EncryptHelper.send(method, value) : value
            end
          end
        })
      end
    end
  end
end
