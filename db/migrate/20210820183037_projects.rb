# frozen_string_literal: true

class Projects < Mongoid::Migration
  def self.up
    Project.all do |project|
      project.rename(project_id: :id)
    end
  end

  def self.down
    Project.all do |project|
      project.rename(id: :project_id)
    end
  end
end
