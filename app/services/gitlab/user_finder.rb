# frozen_string_literal: true

module Gitlab
  class UserFinder < ApplicationService
    # @param [Array<String>] usernames
    def initialize(usernames)
      @usernames = usernames
    end

    # Get username ids
    #
    # @return [Array<Number>]
    def call
      return unless @usernames

      ids = @usernames.map do |user|
        Rails.cache.fetch(user, skip_nil: true, expires_in: 1.week) do
          gitlab.user_search(user).first&.id.tap { |id| logger.error { "User '#{user}' not found!" } unless id }
        end
      end.compact

      ids.any? ? ids : nil
    end
  end
end
