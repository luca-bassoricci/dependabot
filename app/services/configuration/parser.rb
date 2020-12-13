# frozen_string_literal: true

require "yaml"

module Configuration
  class InvalidConfigurationError < StandardError
    def self.format(result)
      result.errors.group_by(&:path).map do |path, messages|
        "#{path.drop(1).join('.')}: #{messages.map(&:text).join('; ')}"
      end.join("\n")
    end
  end

  class Parser < ApplicationService
    PACKAGE_ECOSYSTEM_MAPPING = {
      "npm" => "npm_and_yarn",
      "gomod" => "go_modules",
      "gitsubmodule" => "submodules",
      "mix" => "hex"
    }.freeze

    # @param [String] config dependabot.yml configuration file
    def initialize(config)
      @config = config
    end

    # Parse dependabot configuration
    #
    # @return [Array<Hash>]
    def call
      validate_config

      yml[:updates].map do |configuration|
        {
          **general_options(configuration),
          **branch_options(configuration),
          **commit_message_options(configuration),
          **filter_options(configuration),
          cron: Schedule.call(configuration[:schedule])
        }.compact
      end
    end

    private

    # @return [String] dependabot configuration file
    attr_reader :config

    def validate_config
      result = DependabotConfigContract.new.call(yml)
      return if result.success?

      raise(InvalidConfigurationError, InvalidConfigurationError.format(result))
    end

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
    def general_options(opts)
      package_ecosystem = opts[:"package-ecosystem"]

      {
        # github native implementation modifies some of the names in the config file
        # https://docs.github.com/en/github/administering-a-repository/configuration-options-for-dependency-updates#package-ecosystem
        package_manager: PACKAGE_ECOSYSTEM_MAPPING.fetch(package_ecosystem, package_ecosystem),
        package_ecosystem: package_ecosystem,
        directory: opts[:directory],
        milestone: opts[:milestone],
        assignees: opts[:assignees],
        reviewers: opts[:reviewers],
        custom_labels: opts[:labels],
        open_merge_requests_limit: opts[:"open-pull-requests-limit"] || 5,
        rebase_strategy: opts[:"rebase-strategy"] || "auto",
        auto_merge: opts[:"auto-merge"],
        versioning_strategy: opts[:"versioning-strategy"] || "auto"
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

    # Specific package allow or ignore options
    #
    # @param [Hash<Symbol, Object>] opts
    # @return [Hash<Symbol, Array>]
    def filter_options(opts)
      {
        # Allow all direct dependencies if not explicitly defined
        allow: transform_filter_options(opts[:allow]) || [{ dependency_type: "direct" }],
        ignore: transform_filter_options(opts[:ignore]) || []
      }
    end

    # Transform key names
    #
    # @param [<Type>] opts
    # @return [<Type>] <description>
    def transform_filter_options(opts)
      opts&.map do |opt|
        {
          dependency_name: opt[:"dependency-name"],
          dependency_type: opt[:"dependency-type"],
          versions: opt[:versions]
        }.compact
      end
    end
  end
end
