# frozen_string_literal: true

class ProjectController < ApplicationController
  def execute
    job = Sidekiq::Cron::Job.find(project_name)
    job.enque!
    redirect_to root_path
  end

  # Project name
  #
  # @return [String]
  def project_name
    params.require(:project_name)
  end
end
