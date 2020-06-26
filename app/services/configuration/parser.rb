# frozen_string_literal: true

require "yaml"

module Configuration
  class Parser < ApplicationService
    # @param [String] config dependabot.yml configuration file
    def initialize(config)
      @config = config
    end

    def call
      yml[:updates].each_with_object({}) do |package_manager, hash|
        hash[package_manager[:"package-ecosystem"]] = {
          **options(package_manager),
          **branch_options(package_manager),
          **commit_message_options(package_manager),
          cron: Schedule.call(package_manager[:schedule])
        }.compact
      end
    end

    private

    attr_reader :config

    def yml
      @yml ||= YAML.safe_load(config, symbolize_names: true)
    end

    def branch_options(opts)
      {
        branch: opts[:"target-branch"],
        branch_name_separator: opts.dig(:"pull-request-branch-name", :separator) || "-"
      }
    end

    def options(opts)
      {
        directory: opts[:directory],
        milestone: opts[:milestone],
        assignees: opts[:assignees],
        reviewers: opts[:reviewers],
        custom_labels: opts[:labels]
      }
    end

    def commit_message_options(opts)
      message_options = opts[:"commit-message"]
      return {} unless message_options

      {
        commit_message_options: {
          prefix: message_options[:prefix],
          prefix_development: message_options[:"prefix-development"],
          include_scope: message_options[:include]
        }.compact
      }
    end
  end
end
