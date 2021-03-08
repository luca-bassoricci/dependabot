# frozen_string_literal: true

class Gitlab::Client # rubocop:disable Style/ClassAndModuleChildren
  module MergeRequests
    # Rebase a merge request.
    #
    # @example
    #   Gitlab.rebase_merge_request(5, 42, { skip_ci: true })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :skip_ci Set to true to skip creating a CI pipeline
    # @return [Gitlab::ObjectifiedHash] Information about updated merge request.
    def rebase_merge_request(project, id, options = {})
      put("/projects/#{url_encode project}/merge_requests/#{id}/rebase", body: options)
    end
  end
end
