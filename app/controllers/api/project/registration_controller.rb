# frozen_string_literal: true

module Api
  module Project
    class RegistrationController < ApplicationController
      # Post request handler
      #
      # @return [void]
      def create
        return bad_request unless supported_event?
        return json_response(body: "Skipped, does not match allowed namespace pattern") unless allowed_namespace?

        params.permit(:event_name, :path_with_namespace, :old_path_with_namespace)
        json_response(
          body: Webhooks::SystemHookHandler.call(
            event_name: params[:event_name],
            project_name: params[:path_with_namespace],
            old_project_name: params[:old_path_with_namespace]
          )
        )
      end

      private

      # Check if event is supported
      #
      # @return [Boolean]
      def supported_event?
        %w[project_create project_destroy project_rename project_transfer].include?(params[:event_name])
      end

      # Check if namespace is allowed
      #
      # @return [Boolean]
      def allowed_namespace?
        return true unless AppConfig.project_registration_namespace

        params[:path_with_namespace].match?(Regexp.new(AppConfig.project_registration_namespace))
      end

      # Handle bad request
      #
      # @return [void]
      def bad_request
        json_response(body: { status: 400, error: "Unsupported event or missing parameter 'event_name'" }, status: 400)
      end
    end
  end
end
