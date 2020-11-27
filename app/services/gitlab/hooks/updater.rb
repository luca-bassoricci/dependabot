# frozen_string_literal: true

module Gitlab
  module Hooks
    class Updater < ProjectHook
      # Update existing webhook
      #
      # @return [Integer]
      def call
        logger.info { "Updating webhook for project '#{project.name}'" }
        gitlab.edit_project_hook(project.name, project.webhook_id, hook_url, hook_args).id
      end

      private

      # Hook values need to be updated
      #
      # @return [boolean]
      def changed?
        upstream_hook && hook_args.values != upstream_hook.to_h.values_at(*hook_args.keys)
      end

      # Saved webhook
      #
      # @return [Gitlab::ObjectifiedHash]
      def upstream_hook
        gitlab.project_hook(project.name, project.webhook_id)
      end
    end
  end
end
