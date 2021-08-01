# frozen_string_literal: true

module Webhooks
  class SystemHookHandler < ApplicationService
    def initialize(event_name:, project_name:, old_project_name: nil)
      @event_name = event_name
      @project_name = project_name
      @old_project_name = old_project_name
    end

    def call
      send(event_name)
    end

    private

    attr_reader :event_name,
                :project_name,
                :old_project_name

    # Add project on project_create event
    #
    # @return [Project]
    def project_create
      Dependabot::ProjectCreator.call(project_name).tap { |project| Cron::JobSync.call(project) }
    end

    # Remove project on project_destroy event
    #
    # @return [nil]
    def project_destroy
      Project.find_by(name: project_name)

      Dependabot::ProjectRemover.call(project_name)
      "project removed successfully"
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end

    # Rename project
    #
    # @return [nil]
    def project_rename
      project = Project.find_by(name: old_project_name)

      project.name = project_name
      project.save!

      Cron::JobRemover.call(old_project_name)
      Cron::JobSync.call(project)
      "project updated to #{project_name}"
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end

    # Handle project transfer
    #
    # @return [nil]
    def project_transfer
      project_rename
    end
  end
end
