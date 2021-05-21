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
      return unless usernames

      ids = usernames.map { |user| find_user(user) }.compact
      ids.empty? ? nil : ids
    end

    private

    attr_reader :usernames

    # Find user
    #
    # @param [String] user
    # @return [Integer]
    def find_user(user)
      id = Rails.cache.fetch(user, skip_nil: true, expires_in: 1.week) do
        log(:debug, "Running user search for #{user}")
        gitlab.user_search(user)&.detect { |usr| usr.username == user }&.id
      end
      return id if id

      log(:error, "User '#{user}' not found!")
      nil
    end
  end
end
