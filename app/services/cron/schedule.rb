# frozen_string_literal: true

require "date"
require "digest"

module Cron
  # Parse dependabot schedule data and create cron string
  #
  class Schedule < ApplicationService
    INTERVALS = %w[daily weekday weekly monthly].freeze

    # @param [String] interval
    # @param [String] day
    # @param [String] time
    # @param [String] timezone
    def initialize(project:, interval:, day: nil, time: nil, timezone: nil)
      @project = project
      @interval = INTERVALS.include?(interval) ? interval : "daily"
      @day = Date::DAYNAMES.map(&:downcase).include?(day) ? day[0..2] : nil
      @time = time&.match?(/^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$/) ? time : nil
      @timezone = TZInfo::Timezone.all_identifiers.include?(timezone) ? timezone : Time.zone.name
    end

    # Parse schedule data and return cron string
    #
    # @return [String]
    def call
      cron_time = (time || random_time).split(":").yield_self { |arr| "#{arr[1]} #{arr[0]}" }
      return "#{cron_time} * * #{day || random_day} #{timezone}" if interval == "weekly"
      return "#{cron_time} 1 * * #{timezone}" if interval == "monthly"
      return "#{cron_time} * * 1-5 #{timezone}" if interval == "weekday"

      "#{cron_time} * * * #{timezone}"
    end

    private

    attr_reader :project, :interval, :day, :time, :timezone

    # Random number generator
    #
    # @return [Random]
    def random
      @random ||= Random.new(Digest::MD5.hexdigest(project).to_i(16))
    end

    # Get random time based on project name
    #
    # @return [String]
    def random_time
      hour = random.rand(0..23)
      minute = random.rand(0..59).yield_self { |min| min <= 9 ? "0#{minute}" : minute }

      "#{hour}:#{minute}"
    end

    # Get random day
    #
    # @return [Integer]
    def random_day
      random.rand(0..6)
    end
  end
end
