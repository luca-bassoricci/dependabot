# frozen_string_literal: true

module Webhooks
  class SystemHookHandler < HookHandler
    def initialize(project_name:, event_name:, old_project_name: nil)
      super(project_name)

      @event_name = event_name
      @old_project_name = old_project_name
    end

    def call
      send(event_name)
    end

    private

    attr_reader :event_name, :old_project_name

    # Add project on project_create event
    #
    # @return [Project]
    def project_create
      Dependabot::Projects::Creator.call(project_name)
                                   .tap { |project| Cron::JobSync.call(project) }
                                   .to_hash
    end

    # Remove project on project_destroy event
    #
    # @return [nil]
    def project_destroy
      Dependabot::Projects::Remover.call(project_name)

      "project removed successfully"
    rescue Mongoid::Errors::DocumentNotFound
      log(:error, "Project #{project_name} not found!")
      nil
    end

    # Rename project
    #
    # @return [nil]
    def project_rename
      old_project = Project.find_by(name: old_project_name)

      old_project.update_attributes!(name: project_name)

      Cron::JobRemover.call(old_project_name)
      Cron::JobSync.call(old_project)

      "project updated to #{project_name}"
    rescue Mongoid::Errors::DocumentNotFound
      log(:error, "Project #{old_project_name} not found!")
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
