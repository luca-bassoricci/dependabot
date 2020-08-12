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
      @usernames.map { |user| gitlab.user_search(user).first&.id }
    end
  end
end
