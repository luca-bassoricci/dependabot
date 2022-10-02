# frozen_string_literal: true

class RemoveProjectConfigs < Mongoid::Migration
  def self.up
    Project.all.unset(:config)
    DataMigration.find_by(version: "20211209205330").destroy
  rescue Mongoid::Errors::DocumentNotFound # rubocop:disable Lint/SuppressedException
  end

  def self.down; end
end
