# frozen_string_literal: true

# Helper for storing encrypted strings in database
#
class EncryptedString
  class << self
    # Decrypt string from database
    #
    # @param [String] object
    # @return [String]
    def demongoize(object)
      return unless object

      EncryptHelper.decrypt(object)
    end

    # Convert object to database compatible form
    #
    # @param [String] object
    # @return [String]
    def mongoize(object)
      return unless object

      EncryptHelper.encrypt(object)
    end

    # Convert object supplied as criteria
    #
    # @param [String] object
    # @return [String]
    def evolve(object)
      mongoize(object)
    end
  end
end
