# frozen_string_literal: true

class ProjectController < ApplicationController
  def update
    project = Project.find_by(id: params.require(:id))

    Dependabot::Projects::Creator.call(project.name)
    Cron::JobSync.call(project)

    redirect_to root_path
  end
end
