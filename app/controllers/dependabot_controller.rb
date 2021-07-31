# frozen_string_literal: true

class DependabotController < ApplicationController
  def index
    @jobs = Sidekiq::Cron::Job.all.select { |job| job.klass == "DependencyUpdateJob" }
  end
end
