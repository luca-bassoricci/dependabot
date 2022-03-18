# frozen_string_literal: true

class Registries
  AUTH_FIELDS = %w[token key password].freeze

  def initialize(registries)
    @registries = registries
  end

  delegate :values, :slice, to: :registries

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

  # Registries hash
  #
  # @return [Hash]
  def to_h
    registries
  end

  protected

  # @return [Hash]
  attr_reader :registries

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

    # Encrypt or decrypt auth fields in registries definition
    #
    # @param [Hash] registries
    # @param [Symbol] method
    # @return [Hash]
    def update_auth_fields(registries, method)
      registries.deep_dup.transform_values do |registry|
        AUTH_FIELDS.each do |field|
          registry[field] = EncryptHelper.send(method, registry[field]) if registry.key?(field)
        end

        registry
      end
    end
  end
end
