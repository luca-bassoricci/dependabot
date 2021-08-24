# frozen_string_literal: true

class DependabotController < ApplicationController
  def index
    @projects = Project.not(config: [])
  end
end
