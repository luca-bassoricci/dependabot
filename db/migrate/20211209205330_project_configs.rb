# frozen_string_literal: true

class ProjectConfigs < Mongoid::Migration
  def self.up
    Project.each do |project|
      project.config = Config.new(project.config)
    end
  end

  def self.down
    Project.each do |project|
      project.config = project.config.config_array
    end
  end
end
