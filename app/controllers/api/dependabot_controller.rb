# frozen_string_literal: true

module Api
  class DependabotController < ApplicationController
    def create
      __send__(params[:event_name])
    end

    private

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
