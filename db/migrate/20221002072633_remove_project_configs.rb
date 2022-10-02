# frozen_string_literal: true

class RemoveProjectConfigs < Mongoid::Migration
  def self.up
    Project.all.each { |project| project.unset(:config) }
    DataMigration.find_by(version: "20211209205330")&.destroy
  end

  def self.down; end
end
