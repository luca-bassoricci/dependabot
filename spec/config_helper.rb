# frozen_string_literal: true

require "anyway/testing/helpers"

RSpec.shared_context("with config helper") do
  include Anyway::Testing::Helpers

  def reset_configs
    AppConfig.instance_variable_set(:@instance, nil)
    CredentialsConfig.instance_variable_set(:@instance, nil)
  end

  before { reset_configs }

  after { reset_configs }
end
