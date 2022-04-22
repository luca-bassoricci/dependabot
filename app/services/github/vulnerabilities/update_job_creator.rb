# frozen_string_literal: true

module Github
  module Vulnerabilities
    class UpdateJobCreator < ApplicationService
      def initialize
        @job_name = "Vulnerability database sync"
      end

      def call
        if CredentialsConfig.github_access_token
          return if job_exists?

          log(:info, "Creating vulnerability database update job")
          create
        else
          log(:warn, "GitHub access token missing, security vulnerability integration will be disabled")
          destroy # destroy existing jobs in case token is removed from environment
        end
      end

      private

      attr_reader :job_name

      # Create vulnerability db update jobs for every supported package ecosystem
      # Updates performed every 12 hours
      #
      # @return [void]
      def create
        Sidekiq::Cron::Job.create(
          name: job_name,
          cron: "0 1/12 * * *",
          class: "SecurityVulnerabilityUpdateJob",
          description: "Vulnerability database update",
          active_job: true
        )
      end

      # Destroy db update jobs
      #
      # @return [void]
      def destroy
        Sidekiq::Cron::Job.destroy(job_name) if job_exists?
      end

      # All db update jobs created and in sync
      #
      # @return [Boolean]
      def job_exists?
        Sidekiq::Cron::Job.find(job_name)
      end
    end
  end
end
