# frozen_string_literal: true

require "yaml"

module Dependabot
  class InvalidConfigurationError < StandardError
    def self.format(result)
      result.errors.group_by(&:path).map do |path, messages|
        "key '#{path.join('.')}' #{messages.map(&:dump).join('; ')}"
      end.join("\n")
    end
  end

  # rubocop:disable Metrics/ClassLength
  class ConfigParser < ApplicationService
    # @return [Hash<String, String>]
    PACKAGE_ECOSYSTEM_MAPPING = {
      "npm" => "npm_and_yarn",
      "gomod" => "go_modules",
      "gitsubmodule" => "submodules",
      "mix" => "hex"
    }.freeze
    # @return [Hash<String, Symbol>] mapping for versioning strategies option
    VERSIONING_STRATEGIES = {
      "lockfile-only" => :lockfile_only,
      "widen" => :widen_ranges,
      "increase" => :bump_versions,
      "increase-if-necessary" => :bump_versions_if_necessary
    }.freeze

    # @param [String] config dependabot.yml configuration file
    def initialize(config, project)
      @config = config
      @project = project
    end

    # Parse dependabot configuration
    #
    # @return [Array<Hash>]
    def call
      validate_dependabot_config(DependabotConfigContract, yml)
      validate_dependabot_config(UpdatesConfigContract, { updates: yml[:updates] })

      yml[:updates].map do |configuration|
        {
          **registries_options(configuration),
          **insecure_code_execution_options(configuration),
          **general_options(configuration),
          **branch_options(configuration),
          **commit_message_options(configuration),
          **filter_options(configuration),
          **schedule_options(configuration)
        }.compact
      end
    end

    private

    # @return [String] dependabot configuration file
    attr_reader :config
    # @return [String] project name
    attr_reader :project

    # Validate config schema
    #
    # @param [Dry::Validation::Contract] contract
    # @param [Hash] config
    # @return [void]
    def validate_dependabot_config(contract, conf)
      result = contract.new.call(conf)
      return if result.success?

      raise(InvalidConfigurationError, InvalidConfigurationError.format(result))
    end

    # Parsed dependabot yml config
    #
    # @return [Hash<Symbol, Object>]
    def yml
      @yml ||= YAML.safe_load(config, symbolize_names: true)
    end

    # Allowed registries options
    #
    # @param [Hash] opts
    # @return [Array<Hash>]
    def registries_options(opts)
      allowed = opts[:registries] || "*"
      defined_registries = yml[:registries] || {}
      registries = allowed == "*" ? defined_registries.values : allowed.map { |reg| defined_registries[reg.to_sym] }

      {
        registries: RegistriesParser.call(registries: registries)
      }
    end

    # Insecure code execution options
    #
    # @param [Hash] opts
    # @return [Hash]
    def insecure_code_execution_options(opts)
      ext_execution = opts[:"insecure-external-code-execution"]
      return { reject_external_code: true } if yml[:registries] && ext_execution.nil?

      { reject_external_code: ext_execution.nil? ? false : ext_execution != "allow" }
    end

    # Branch related options
    #
    # @param [Hash<Symbol, Object>] opts
    # @return [Hash<Symbol, Object>]
    def branch_options(opts)
      {
        branch: opts[:"target-branch"],
        branch_name_prefix: opts.dig(:"pull-request-branch-name", :prefix) || "dependabot",
        branch_name_separator: opts.dig(
          :"pull-request-branch-name", :separator
        ) || DependabotConfig.branch_name_separator
      }
    end

    # General options
    #
    # @param [Hash<Symbol, Object>] opts
    # @return [Hash<Symbol, Object>]
    def general_options(opts) # rubocop:disable Metrics/MethodLength
      package_ecosystem = opts[:"package-ecosystem"]

      {
        # github native implementation modifies some of the names in the config file
        # https://docs.github.com/en/github/administering-a-repository/configuration-options-for-dependency-updates#package-ecosystem
        package_manager: PACKAGE_ECOSYSTEM_MAPPING.fetch(package_ecosystem, package_ecosystem),
        package_ecosystem: package_ecosystem,
        vendor: opts[:vendor],
        directory: opts[:directory],
        milestone: opts[:milestone],
        assignees: opts[:assignees],
        reviewers: opts[:reviewers],
        approvers: opts[:approvers],
        custom_labels: opts[:labels],
        open_merge_requests_limit: opts[:"open-pull-requests-limit"] || DependabotConfig.open_pull_request_limit,
        rebase_strategy: opts[:"rebase-strategy"] || "auto",
        auto_merge: opts[:"auto-merge"],
        versioning_strategy: versioning_strategy(opts[:"versioning-strategy"]),
        fork: yml[:fork]
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

    # Cron options
    #
    # @param [Hash<Symbol, Object>] opts
    # @return [Hash<Symbol, String>]
    def schedule_options(opts)
      return {} unless opts[:schedule]

      entry = "#{project}-#{opts[:"package-ecosystem"]}-#{opts[:directory]}"
      { cron: Cron::Schedule.call(entry: entry, **opts[:schedule]) }
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
          versions: opt[:versions],
          update_types: opt[:"update-types"]
        }.compact
      end
    end

    def versioning_strategy(strategy)
      return unless strategy

      VERSIONING_STRATEGIES.fetch(strategy) do |el|
        log(:error, "Unsupported versioning-strategy #{el}")
        nil
      end
    end
  end
  # rubocop:enable Metrics/ClassLength
end
