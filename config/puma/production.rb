# frozen_string_literal: true

lowlevel_error_handler do |ex, env|
  Raven.capture_exception(
    ex,
    message: ex.message,
    extra: { puma: env },
    transaction: "Puma"
  )

  [500, {}, ["An error has occurred, and engineers have been informed."]]
end
