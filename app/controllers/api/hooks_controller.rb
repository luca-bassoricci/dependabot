# frozen_string_literal: true

module Api
  class HooksController < ApplicationController
    # Post request handler
    #
    # @return [void]
    def create
      params[:object_kind].tap do |hook|
        respond_to?(hook || "", true) ? json_response(body: send(hook)) : bad_request
      end
    end

    private

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
        project: [:path_with_namespace],
        commits: [
          added: [],
          modified: [],
          removed: []
        ]
      )

      Webhooks::PushEventHandler.call(
        project_name: args.dig(:project, :path_with_namespace),
        commits: args[:commits]
      )
    end

    # Handle merge_request hook event
    #
    # @return [void]
    def merge_request
      args = params.permit(
        object_attributes: %i[iid action],
        project: [:path_with_namespace]
      )
      return unless %w[close merge reopen].include?(args.dig(:object_attributes, :action))

      Webhooks::MergeRequestEventHandler.call(
        project_name: args.dig(:project, :path_with_namespace),
        mr_iid: args.dig(:object_attributes, :iid),
        action: args.dig(:object_attributes, :action)
      )
    end

    # Handle comment hook event
    #
    # @return [void]
    def note
      args = params.permit(
        object_attributes: %i[discussion_id note],
        project: [:path_with_namespace],
        merge_request: [:iid]
      )

      Webhooks::CommentEventHandler.call(
        project_name: args.dig(:project, :path_with_namespace),
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
        project: [:path_with_namespace],
        merge_request: %i[iid merge_status]
      )

      Webhooks::PipelineEventHandler.call(
        source: args.dig(:object_attributes, :source),
        status: args.dig(:object_attributes, :status),
        project_name: args.dig(:project, :path_with_namespace),
        mr_iid: args.dig(:merge_request, :iid),
        merge_status: args.dig(:merge_request, :merge_status)
      )
    end
  end
end
