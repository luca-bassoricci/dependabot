# frozen_string_literal: true

module Gitlab
  module Hooks
    class Finder < ProjectHook
      # Check if hook already exists
      #
      # @return [Integer]
      def call
        gitlab.project_hooks(project_name)
              .auto_paginate
              .detect { |hook| hook.url == hook_url }
              &.id
      end
    end
  end
end
