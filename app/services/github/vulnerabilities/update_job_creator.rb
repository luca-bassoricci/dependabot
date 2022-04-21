# frozen_string_literal: true

module Github
  module Vulnerabilities
    class UpdateJobCreator < ApplicationService
      def call
        if CredentialsConfig.github_access_token
          return if synced?

          log(:info, "Creating vulnerability database update jobs")
          create
        else
          log(:warn, "GitHub access token missing, security vulnerability integration will be disabled")
          destroy # destroy existing jobs in case token is removed from environment
        end
      end

      private

      # Create vulnerability db update jobs for every supported package ecosystem
      # Updates performed every 12 hours
      #
      # @return [void]
      def create
        Fetcher::PACKAGE_ECOSYSTEMS.keys.each_with_index do |ecosystem, index|
          Sidekiq::Cron::Job.create(
            name: job_name(ecosystem),
            cron: "0 #{index + 1}/12 * * *",
            args: ecosystem,
            class: "SecurityVulnerabilityUpdateJob",
            description: "Update security vulnerabilities for #{ecosystem}",
            active_job: true
          )
        end
      end

      # Destroy db update jobs
      #
      # @return [void]
      def destroy
        Fetcher::PACKAGE_ECOSYSTEMS.each_key do |ecosystem|
          name = job_name(ecosystem)
          Sidekiq::Cron::Job.destroy(name) if Sidekiq::Cron::Job.find(name)
        end
      end

      # All db update jobs created and in sync
      #
      # @return [Boolean]
      def synced?
        Fetcher::PACKAGE_ECOSYSTEMS.each_key.all? do |ecosystem|
          Sidekiq::Cron::Job.find(job_name(ecosystem))
        end
      end

      # Ecosystem specific job name
      #
      # @param [String] ecosystem
      # @return [String]
      def job_name(ecosystem)
        "#{ecosystem} vulnerability sync"
      end
    end
  end
end
