# frozen_string_literal: true

module Gitlab
  module Hooks
    class Updater < ProjectHook
      # Update existing webhook
      #
      # @return [Integer]
      def call
        logger.info { "Updating webhook for project '#{project.name}'" }
        gitlab.edit_project_hook(project_name, webhook_id, hook_url, hook_args).id
      end
    end
  end
end
