# frozen_string_literal: true

require "date"

module Configuration
  class Schedule < ApplicationService
    INTERVALS = %w[daily weekly monthly].freeze

    def initialize(interval:, day: nil, time: nil, timezone: nil)
      @interval = INTERVALS.include?(interval) ? interval : "daily"
      @day = Date::DAYNAMES.map(&:downcase).include?(day) ? day[0..2] : "mon"
      @time = time&.match?(/^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$/) ? time : "5:00"
      @timezone = TZInfo::Timezone.all_identifiers.include?(timezone) ? timezone : Time.zone.name
    end

    def call
      cron_time = time.split(":").yield_self { |arr| "#{arr[1]} #{arr[0]}" }
      return "#{cron_time} * * #{day} #{timezone}" if interval == "weekly"

      "#{cron_time} #{interval == 'daily' ? '*' : '1'} * * #{timezone}"
    end

    private

    attr_reader :interval, :day, :time, :timezone
  end
end
