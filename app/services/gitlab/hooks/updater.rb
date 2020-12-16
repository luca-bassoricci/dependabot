# frozen_string_literal: true

module Gitlab
  module Hooks
    class Updater < ProjectHook
      # Update existing webhook
      #
      # @return [Integer]
      def call
        log(:info, "Updating webhook for project '#{project_name}'")
        gitlab.edit_project_hook(project_name, webhook_id, hook_url, hook_args).id
      end
    end
  end
end
