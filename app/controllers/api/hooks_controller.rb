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

      Webhooks::PushEventHandler.call(args.dig(:project, :path_with_namespace), args[:commits])
    end

    # Handle merge_request hook event
    #
    # @return [void]
    def merge_request
      args = params.permit(
        object_attributes: %i[iid action],
        project: [:path_with_namespace]
      )
      return unless %w[close merge].include?(args.dig(:object_attributes, :action))

      Webhooks::MergeRequestEventHandler.call(
        args.dig(:project, :path_with_namespace),
        args.dig(:object_attributes, :iid)
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
        args.dig(:object_attributes, :discussion_id),
        args.dig(:object_attributes, :note),
        args.dig(:project, :path_with_namespace),
        args.dig(:merge_request, :iid)
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
        args.dig(:object_attributes, :source),
        args.dig(:object_attributes, :status),
        args.dig(:project, :path_with_namespace),
        args.dig(:merge_request, :iid),
        args.dig(:merge_request, :merge_status)
      )
    end
  end
end
