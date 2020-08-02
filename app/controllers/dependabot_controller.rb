# frozen_string_literal: true

class DependabotController < ApplicationController
  def index
    @jobs = Sidekiq::Cron::Job.all
  end
end
