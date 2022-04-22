# frozen_string_literal: true

module Dependabot
  module Projects
    module Registration
      class JobCreator < ApplicationService
        JOB_NAME = "Project Registration"

        # Create or destroy project registration job
        #
        # @return [void]
        def call
          if mode == "automatic" && !job_synced?
            create
          elsif %w[manual system_hook].include?(mode) && job
            destroy
          end
        end

        private

        # Create project registration job
        #
        # @return [void]
        def create
          log(:info, "Creating project registration job")
          Sidekiq::Cron::Job.create(
            name: JOB_NAME,
            cron: cron,
            class: "ProjectRegistrationJob",
            active_job: true,
            description: "Automatically register projects for update"
          )
        end

        # Remove project registration job
        #
        # @return [void]
        def destroy
          log(:info, "Removing project registration job")
          Sidekiq::Cron::Job.destroy(JOB_NAME)
        end

        # Existing job
        #
        # @return [Sidekiq::Cron::Job]
        def job
          @job ||= Sidekiq::Cron::Job.find(JOB_NAME)
        end

        # Job with synced cron
        #
        # @return [Boolean]
        def job_synced?
          job&.cron&.include?(cron)
        end

        # Job cron
        #
        # @return [String]
        def cron
          @cron ||= AppConfig.project_registration_cron
        end

        # Project registration mode
        #
        # @return [String]
        def mode
          @mode ||= AppConfig.project_registration
        end
      end
    end
  end
end
