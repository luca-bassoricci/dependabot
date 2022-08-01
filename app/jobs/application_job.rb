# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  include ApplicationHelper

  before_perform do |job|
    next if AppConfig.standalone?
    next unless job.arguments.first.is_a?(Hash)

    project_name = job.arguments.first.symbolize_keys[:project_name]
    next unless project_name

    Gitlab::ClientWithRetry.client_access_token = find_project(project_name)&.gitlab_access_token
  end
end
