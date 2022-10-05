# frozen_string_literal: true

class ConfigAutoMerge < Mongoid::Migration
  def self.up
    Project.each do |project|
      next unless project.configuration

      project.configuration.updates.each do |entry|
        auto_merge = entry[:auto_merge]

        entry.delete(:auto_merge) if auto_merge && (!auto_merge.key?(:allow) && !auto_merge.key?(:ignore))
      end

      project.save!
    end
  end

  def self.down; end
end
