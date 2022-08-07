# frozen_string_literal: true

class FullContainerScan
  include ApplicationHelper
  using Rainbow

  Rainbow.enabled = true

  SEVERITY_ORDER = {
    "low" => 2,
    "medium" => 1,
    "high" => 0
  }.freeze

  def initialize(app_image)
    @app_image = app_image
  end

  # Run full container scan
  #
  # @return [void]
  def run
    log(:info, "Running vulnerability container scan for image: #{app_image.underline}".magenta)

    log_base_vulnerabilities
    log_app_vulnerabilities

    exit(1) if fail? # rubocop:disable Rails/Exit
  end

  private

  attr_reader :app_image

  def vulnerabilities
    @vulnerabilities ||= uniq_vulnerabilities(result_json[:vulnerabilities])
  end

  # Scanned applications
  #
  # @return [Array]
  def applications
    @applications ||= result_json[:applications]
                      .reject { |app| app[:targetFile].match?(/test|helpers/) }
                      .sort_by { |app| app[:packageManager] }
                      .map { |app| app.merge({ vulnerabilities: uniq_vulnerabilities(app[:vulnerabilities]) }) }
  end

  # Scan result
  #
  # @return [String]
  def scan_result
    @scan_result ||= `snyk container test #{app_image} --file=Dockerfile --exclude-base-image-vulns --app-vulns --json`
  end

  # Scan result json
  #
  # @return [Hash]
  def result_json
    @result_json ||= JSON.parse(scan_result, symbolize_names: true)
  end

  # Fail if upgradeable
  #
  # @return [Boolean]
  def fail?
    vulnerabilities.any? { |vuln| vuln[:isUpgradable] }
  end

  # Log base dockerfile vulnerabilities
  #
  # @return [void]
  def log_base_vulnerabilities
    return if vulnerabilities.empty?

    log(:info, "Following Dockerfile vulnerabilities found!".yellow)
    vulnerabilities.each do |vulnerability|
      log(:info, <<~MSG)

        #{message(vulnerability: vulnerability).strip}
          Image layer: #{vulnerability[:dockerfileInstruction]}
      MSG
    end
  end

  # :reek:TooManyStatements

  # Log app vulnerabilities
  #
  # @return [void]
  def log_app_vulnerabilities
    return if applications.empty? || applications.all? { |app| app[:vulnerabilities].empty? }

    log(:info, "Following app vulnerabilities found!".yellow)
    applications.each do |app|
      vulnerabilities = app[:vulnerabilities]
      next if vulnerabilities.empty?

      msg = ["#{'Package manager:'.bold} #{app[:packageManager]}"]
      msg << "#{'Target file:'.bold} #{app[:targetFile]}"

      vulnerabilities.each { |vulnerability| msg << message(vulnerability: vulnerability) }
      log(:info, "\n#{msg.join("\n")}")
    end
  end

  # Single vulnerability message
  #
  # @param [Hash] vulnerability
  # @return [String]
  def message(vulnerability:)
    severity = vulnerability[:severity]
    vuln_message = "✗ #{severity.capitalize} severity vulnerability found in #{vulnerability[:name].underline}"
    <<~MSG
      #{colorize_severity(severity, vuln_message)}
        Description: #{vulnerability[:title]}
        Info: https://security.snyk.io/vuln/#{vulnerability[:id]}
        Upgradable: #{vulnerability[:isUpgradable]}
    MSG
  end

  # :reek:ControlParameter

  # Colorize severity message
  #
  # @param [String] severity
  # @param [String] msg
  # @return [Symbol]
  def colorize_severity(severity, msg)
    case severity
    when "high"
      msg.bright.red
    when "medium"
      msg.bright.yellow
    else
      msg.yellow
    end
  end

  # Filter and sort vulnerabilities
  #
  # @param [Array<Hash>] vulnerabilities
  # @return [Hash]
  def uniq_vulnerabilities(vulnerabilities)
    vulnerabilities
      .uniq { |vuln| vuln[:id] }
      .sort_by { |vuln| SEVERITY_ORDER.fetch(vuln[:severity], 0) }
  end
end
