# frozen_string_literal: true

class ConfigurationWithRegistries < Mongoid::Migration
  def self.up
    Project.each do |project|
      project.update_attributes!(configuration: Dependabot::Config::Fetcher.call(project.name))
    end
  end

  def self.down
    Project.each do |project|
      project.unset(:configuration)
    end
  end
end
