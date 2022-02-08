# frozen_string_literal: true

require "date"
require "digest"

module Cron
  # Parse dependabot schedule data and create cron string
  #
  class Schedule < ApplicationService
    INTERVALS = %w[daily weekday weekly monthly].freeze

    # @param [String] entry
    # @param [String] interval
    # @param [Hash] cron_args
    def initialize(entry:, interval:, **cron_args)
      @entry = entry
      @interval = INTERVALS.include?(interval) ? interval : "daily"
      @cron_args = cron_args
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

    attr_reader :entry, :interval, :cron_args

    # Day to run update job
    #
    # @return [String, Integer]
    def day
      @day ||= Date::DAYNAMES.map(&:downcase).include?(cron_args[:day]) ? cron_args[:day][0..2] : random_day
    end

    # Time to run updates on
    #
    # @return [String]
    def time
      @time ||= cron_args[:time]&.match?(/^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$/) ? cron_args[:time] : random_time
    end

    # Schedule timezone
    #
    # @return [String]
    def timezone
      @timezone ||= if TZInfo::Timezone.all_identifiers.include?(cron_args[:timezone])
                      cron_args[:timezone]
                    else
                      Time.zone.name
                    end
    end

    # Specific hour range for schedule
    #
    # @return [Range]
    def hours
      @hours ||= if cron_args[:hours]
                   cron_args[:hours]
                     .split("-")
                     .map(&:to_i)
                     .yield_self { |range| (range[0]..range[1]) }
                 else
                   (0..23)
                 end
    end

    # Random number generator
    #
    # @return [Random]
    def random
      @random ||= Random.new(Digest::MD5.hexdigest(entry).to_i(16))
    end

    # Get random time based on project name
    #
    # @return [String]
    def random_time
      hour = random.rand(hours)
      minute = random.rand(0..59)

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
