# frozen_string_literal: true

module EncryptHelper
  # Encrypt string
  #
  # @param [String] string
  # @return [String]
  def encrypt(string)
    len   = ActiveSupport::MessageEncryptor.key_len
    salt  = SecureRandom.hex(len)
    key   = ActiveSupport::KeyGenerator.new(Rails.application.secret_key_base).generate_key(salt, len)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    encrypted_data = crypt.encrypt_and_sign(string)

    "#{salt}$$#{encrypted_data}"
  end

  # Decrypt string
  #
  # @param [String] string
  # @return [String]
  def decrypt(string)
    salt, data = string.split("$$")

    return string unless salt && data

    len   = ActiveSupport::MessageEncryptor.key_len
    key   = ActiveSupport::KeyGenerator.new(Rails.application.secret_key_base).generate_key(salt, len)
    crypt = ActiveSupport::MessageEncryptor.new(key)

    crypt.decrypt_and_verify(data)
  end

  module_function :encrypt, :decrypt
end
