# frozen_string_literal: true

RSpec.shared_examples("settings") do
  def with_settings(env)
    ClimateControl.modify(env) do
      Settings.reload!
      yield
    end
    Settings.reload!
  end
end
