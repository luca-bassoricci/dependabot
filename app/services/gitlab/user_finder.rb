# frozen_string_literal: true

module Gitlab
  class UserFinder < ApplicationService
    def initialize(usernames)
      @usernames = usernames
    end

    def call
      @usernames.map { |user| gitlab.user_search(user).first&.id }
    end
  end
end
