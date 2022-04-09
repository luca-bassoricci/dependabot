# frozen_string_literal: true

module Util
  # Gitlab client
  #
  # @return [Gitlab::Client]
  def gitlab
    @gitlab ||= Gitlab.client(
      endpoint: "https://gitlab.com/api/v4",
      private_token: ENV["GITLAB_ACCESS_TOKEN"]
    )
  end

  # Logger instance
  #
  # @return [Logger]
  def logger
    @logger ||= Logger.new($stdout)
  end
end
