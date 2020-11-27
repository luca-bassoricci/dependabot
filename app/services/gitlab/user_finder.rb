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
      @usernames&.map do |user|
        Rails.cache.fetch(user, skip_nil: true, expires_in: 1.hour) { gitlab.user_search(user).first&.id }
      end
    end
  end
end
