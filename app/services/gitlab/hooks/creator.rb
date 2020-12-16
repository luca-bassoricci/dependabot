# frozen_string_literal: true

module Gitlab
  module Hooks
    class Creator < ProjectHook
      # Add project hooks
      #
      # @return [Integer]
      def call
        log(:info, "Creating webhooks for project '#{project_name}'")
        gitlab.add_project_hook(project_name, hook_url, hook_args).id
      end
    end
  end
end
