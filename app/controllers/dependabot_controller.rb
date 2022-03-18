# frozen_string_literal: true

class DependabotController < ApplicationController
  def index
    @projects = Project.not(configuration: nil)
  end
end
