# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    include Response
    include ExceptionHandler
  end
end
