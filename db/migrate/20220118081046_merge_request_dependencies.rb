# frozen_string_literal: true

class MergeRequestDependencies < Mongoid::Migration
  def self.up
    MergeRequest.each do |mr|
      mr.rename(dependencies: :update_from)
    end
  end

  def self.down
    MergeRequest.each do |mr|
      mr.rename(update_from: :dependencies)
    end
  end
end
