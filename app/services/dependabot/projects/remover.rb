# frozen_string_literal: true

module Dependabot
  module Projects
    class Remover < ApplicationService
      def initialize(project_id)
        @project_id = project_id
      end

      def call
        remove_project
        delete_all_jobs
      end

      private

      attr_reader :project_id

      # Project
      #
      # @return [Project]
      def project
        @project ||= begin
          find_by = project_id.is_a?(Integer) ? { id: project_id } : { name: project_id }
          Project.find_by(**find_by)
        end
      end

      # Delete project
      #
      # @return [void]
      def remove_project
        log(:info, "Removing project: #{project_id}")
        project.destroy
      rescue Mongoid::Errors::DocumentNotFound
        log(:error, "Project #{project_id} doesn't exist!")
      end

      # Delete dependency update jobs
      #
      # @return [void]
      def delete_all_jobs
        Cron::JobRemover.call(project.name)
      end
    end
  end
end
