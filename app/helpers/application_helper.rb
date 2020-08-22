# frozen_string_literal: true

module ApplicationHelper
  # Get gitlab client
  #
  # @return [Gitlab::Client]
  def gitlab
    Gitlab.client(
      endpoint: "#{Settings.gitlab_url}/api/v4",
      private_token: Settings.gitlab_access_token
    )
  end
end
