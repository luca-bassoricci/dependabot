# frozen_string_literal: true

module Api
  class HooksController < ApplicationController
    # Post request handler
    #
    # @return [void]
    def create
      init_gitlab if project_name

      params[:object_kind].tap do |hook|
        respond_to?(hook || "", true) ? json_response(body: send(hook)) : bad_request
      end
    end

    private

    # Initialize gitlab client with correct access token
    #
    # @return [void]
    def init_gitlab
      Gitlab::ClientWithRetry.client_access_token = find_project(project_name).gitlab_access_token
    end

    # Project name
    #
    # @return [String]
    def project_name
      @project_name ||= params
                        .permit(project: [:path_with_namespace])
                        .dig(:project, :path_with_namespace)
    end

    # Handle bad request
    #
    # @return [void]
    def bad_request
      json_response(body: { status: 400, error: "Unsupported or missing parameter 'object_kind'" }, status: 400)
    end

    # Handle push hook event
    #
    # @return [void]
    def push
      args = params.permit(
        commits: [
          added: [],
          modified: [],
          removed: []
        ]
      )

      Webhooks::PushEventHandler.call(
        project_name: project_name,
        commits: args[:commits]
      )
    end

    # Handle merge_request hook event
    #
    # @return [void]
    def merge_request
      args = params.permit(object_attributes: %i[iid action merge_status])
      return unless %w[close merge reopen approved].include?(args.dig(:object_attributes, :action))

      Webhooks::MergeRequestEventHandler.call(
        project_name: project_name,
        mr_iid: args.dig(:object_attributes, :iid),
        action: args.dig(:object_attributes, :action),
        merge_status: args.dig(:object_attributes, :merge_status)
      )
    end

    # Handle comment hook event
    #
    # @return [void]
    def note
      args = params.permit(
        object_attributes: %i[discussion_id note],
        merge_request: [:iid]
      )

      Webhooks::CommentEventHandler.call(
        project_name: project_name,
        mr_iid: args.dig(:merge_request, :iid),
        discussion_id: args.dig(:object_attributes, :discussion_id),
        note: args.dig(:object_attributes, :note)
      )
    end

    # Handle pipeline hook event
    #
    # @return [void]
    def pipeline
      args = params.permit(
        object_attributes: %i[source status],
        merge_request: %i[
          iid
          merge_status
          source_project_id
          target_project_id
        ]
      )

      Webhooks::PipelineEventHandler.call(
        project_name: project_name,
        source: args.dig(:object_attributes, :source),
        status: args.dig(:object_attributes, :status),
        mr_iid: args.dig(:merge_request, :iid),
        merge_status: args.dig(:merge_request, :merge_status),
        source_project_id: args.dig(:merge_request, :source_project_id),
        target_project_id: args.dig(:merge_request, :target_project_id)
      )
    end

    # Handle issue hook event
    #
    # @return [void]
    def issue
      args = params.permit(object_attributes: %i[iid action])
      return unless args.dig(:object_attributes, :action) == "close"

      Webhooks::IssueEventHandler.call(
        project_name: project_name,
        issue_iid: args.dig(:object_attributes, :iid)
      )
    end
  end
end
