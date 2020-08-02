# frozen_string_literal: true

module Api
  class DependabotController < ApplicationController
    def create
      params[:object_kind].tap do |hook|
        respond_to?(hook, true) ? json_response(__send__(hook)) : bad_request
      end
    end

    private

    def bad_request
      json_response({ status: 400, error: "Unsupported or missing parameter 'object_kind'" }, 400)
    end

    # Handle push hook trigger
    # @return [void]
    def push
      Webhooks::PushEventHandler.call(
        params.permit(
          project: [
            :path_with_namespace
          ],
          commits: [
            added: [],
            modified: [],
            removed: []
          ]
        )
      )
    end
  end
end
