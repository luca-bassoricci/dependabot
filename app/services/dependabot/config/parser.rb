# frozen_string_literal: true

require "yaml"

module Dependabot
  module Config
    class InvalidConfigurationError < StandardError
      def self.format(result)
        result.errors.group_by(&:path).map do |path, messages|
          "key '#{path.join('.')}' #{messages.map(&:dump).join('; ')}"
        end.join("\n")
      end
    end

    # rubocop:disable Metrics/ClassLength
    class Parser < ApplicationService
      # @return [Hash<String, Symbol>] mapping for versioning strategies option
      VERSIONING_STRATEGIES = {
        "lockfile-only" => :lockfile_only,
        "widen" => :widen_ranges,
        "increase" => :bump_versions,
        "increase-if-necessary" => :bump_versions_if_necessary
      }.freeze

      # @param [String] config dependabot.yml configuration file
      # @param [String] project name of the project
      def initialize(config, project)
        @config = config
        @project = project
      end

      delegate :config_base_filename, to: "DependabotConfig"

      # Parse dependabot configuration
      #
      # @return [Array<Hash>]
      def call
        merged_config = base_config.deep_merge({
          **yml,
          updates: yml[:updates].map { |entry| (base_config[:updates] || {}).deep_merge(entry) }
        })

        validate_dependabot_config(DependabotConfigContract, merged_config)
        validate_dependabot_config(UpdatesConfigContract, merged_config.slice(:updates))

        {
          registries: RegistriesParser.call(registries: merged_config[:registries]),
          updates: merged_config[:updates].map do |configuration|
            {
              **general_options(configuration),
              **insecure_code_execution_options(configuration),
              **branch_options(configuration),
              **commit_message_options(configuration),
              **filter_options(configuration),
              **schedule_options(configuration),
              **auto_merge_options(configuration),
              **rebase_options(configuration),
              **vulnerability_alert_options(configuration)
            }.compact
          end
        }
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

      # Base configuration
      #
      # @return [Hash]
      def base_config
        @base_config ||= begin
          return {} unless config_base_filename && File.exist?(config_base_filename)

          base = YAML.load_file(config_base_filename, symbolize_names: true)
          return {} unless base
          return base if base[:updates].nil? || base[:updates].is_a?(Hash)

          raise(
            InvalidConfigurationError,
            "`updates` key in base configuration `#{config_base_filename}` must be a map!"
          )
        end
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
      def general_options(opts)
        package_ecosystem = opts[:"package-ecosystem"]

        {
          # github native implementation modifies some of the names in the config file
          # https://docs.github.com/en/github/administering-a-repository/configuration-options-for-dependency-updates#package-ecosystem
          package_manager: Ecosystem::PACKAGE_ECOSYSTEM_MAPPING.fetch(package_ecosystem, package_ecosystem),
          package_ecosystem: package_ecosystem,
          fork: yml[:fork],
          vendor: opts[:vendor],
          directory: opts[:directory],
          milestone: opts[:milestone],
          assignees: opts[:assignees],
          reviewers: opts[:reviewers],
          approvers: opts[:approvers],
          custom_labels: opts[:labels],
          registries: opts[:registries] || "*",
          versioning_strategy: versioning_strategy(opts[:"versioning-strategy"]),
          open_merge_requests_limit: opts[:"open-pull-requests-limit"] || DependabotConfig.open_pull_request_limit,
          updater_options: opts[:"updater-options"] || {}
        }
      end

      # Rebase options
      #
      # @param [Hash<Symbol, Object>] opts
      # @return [Hash<Symbol, Object>]
      def rebase_options(opts)
        strategy = opts[:"rebase-strategy"] || "auto"
        return { rebase_strategy: { strategy: strategy } } if strategy.is_a?(String)

        validate_dependabot_config(RebaseStrategyConfigContract, { "rebase-strategy": strategy })

        {
          rebase_strategy: {
            strategy: strategy[:strategy] || "auto",
            on_approval: strategy[:"on-approval"],
            with_assignee: strategy[:"with-assignee"]
          }
        }
      end

      # Auto merge options
      #
      # @param [Hash] opts
      # @return [Hash]
      def auto_merge_options(opts)
        auto_merge = opts[:"auto-merge"]
        return {} unless auto_merge
        return { auto_merge: { dependency_name: "*" } } if auto_merge == true

        validate_dependabot_config(AutoMergeConfigContract, { "auto-merge": auto_merge })

        {
          auto_merge: {
            allow: transform_filter_options(auto_merge[:allow]),
            ignore: transform_filter_options(auto_merge[:ignore])
          }.compact
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
            include_scope: message_options[:include],
            trailers: message_options[:trailers]&.reduce({}, :merge)
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

        {
          cron: Cron::Schedule.call(
            entry: "#{project}-#{opts[:"package-ecosystem"]}-#{opts[:directory]}",
            **opts[:schedule]
          )
        }
      end

      # Vulnerability alert options
      #
      # @param [Hash<Symbol, Object>] opts
      # @return [Hash<Symbol, Object>]
      def vulnerability_alert_options(opts)
        global_option = yml[:"vulnerability-alerts"].nil? ? { enabled: true } : yml[:"vulnerability-alerts"]
        entry_option = opts[:"vulnerability-alerts"] || {}

        {
          vulnerability_alerts: global_option.merge(entry_option)
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
end
