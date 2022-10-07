# frozen_string_literal: true

class JobController < ApplicationController
  def execute
    job = Update::Job.find(params.require(:id))
    project = Project.find(job.project_id)

    DependencyUpdateJob.perform_later(
      project_name: project.name,
      package_ecosystem: job.package_ecosystem,
      directory: job.directory
    )

    redirect_to root_path
  end
end
