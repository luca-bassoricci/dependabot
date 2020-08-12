# frozen_string_literal: true

require "yaml"

module Configuration
  class Parser < ApplicationService
    # @param [String] config dependabot.yml configuration file
    def initialize(config)
      @config = config
    end

    # Parse dependabot configuration
    #
    # @return [Hash<Symbol, Object>]
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

    # @return [String] dependabot configuration file
    attr_reader :config

    # Parsed dependabot yml config
    #
    # @return [Hash<Symbol, Object>]
    def yml
      @yml ||= YAML.safe_load(config, symbolize_names: true)
    end

    # Branch related options
    #
    # @param [Hash<Symbol, Object>] opts
    # @return [Hash<Symbol, Object>]
    def branch_options(opts)
      {
        branch: opts[:"target-branch"],
        branch_name_separator: opts.dig(:"pull-request-branch-name", :separator) || "-",
        branch_name_prefix: opts.dig(:"pull-request-branch-name", :prefix) || "dependabot"
      }
    end

    # General options
    #
    # @param [Hash<Symbol, Object>] opts
    # @return [Hash<Symbol, Object>]
    def options(opts)
      {
        directory: opts[:directory],
        milestone: opts[:milestone],
        assignees: opts[:assignees],
        reviewers: opts[:reviewers],
        custom_labels: opts[:labels]
      }
    end

    # Commit message related options
    #
    # @param [Hash<Symbol, Object>] opts
    # @return [Hash<Symbol, Object>]
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
