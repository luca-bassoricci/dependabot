# frozen_string_literal: true

module ApplicationHelper
  def gitlab
    Gitlab.client(
      endpoint: "https://#{Settings.gitlab_hostname}/api/v4",
      private_token: Settings.gitlab_access_token
    )
  end
end
