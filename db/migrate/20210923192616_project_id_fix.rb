# frozen_string_literal: true

class ProjectIdFix < Mongoid::Migration
  def self.up
    Project.each do |project|
      project.rename(project_id: :id)
    end
  end

  def self.down
    Project.each do |project|
      project.rename(id: :project_id)
    end
  end
end
