# frozen_string_literal: true

class UpdaterOptions < Mongoid::Migration
  def self.up
    Project.all.each do |project|
      project.configuration.updates.each do |entry|
        entry[:updater_options] = {} unless entry[:updater_options]
      end

      project.save!
    end
  end

  def self.down
    Project.all.each do |project|
      project.configuration.updates.each do |entry|
        entry.delete(:updater_options)
      end

      project.save!
    end
  end
end
