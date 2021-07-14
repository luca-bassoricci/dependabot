# frozen_string_literal: true

require "date"

module Cron
  # Parse dependabot schedule data and create cron string
  #
  class Schedule < ApplicationService
    INTERVALS = %w[daily weekday weekly monthly].freeze

    # @param [String] interval
    # @param [String] day
    # @param [String] time
    # @param [String] timezone
    def initialize(interval:, day: nil, time: nil, timezone: nil)
      @interval = INTERVALS.include?(interval) ? interval : "daily"
      @day = Date::DAYNAMES.map(&:downcase).include?(day) ? day[0..2] : "mon"
      @time = time&.match?(/^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$/) ? time : "5:00"
      @timezone = TZInfo::Timezone.all_identifiers.include?(timezone) ? timezone : Time.zone.name
    end

    # Parse schedule data and return cron string
    #
    # @return [String]
    def call
      cron_time = time.split(":").yield_self { |arr| "#{arr[1]} #{arr[0]}" }
      return "#{cron_time} * * #{day} #{timezone}" if interval == "weekly"
      return "#{cron_time} 1 * * #{timezone}" if interval == "monthly"
      return "#{cron_time} * * 1-5 #{timezone}" if interval == "weekday"

      "#{cron_time} * * * #{timezone}"
    end

    private

    attr_reader :interval, :day, :time, :timezone
  end
end
