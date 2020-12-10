# frozen_string_literal: true

# Patch dependabot mention sanitizer so it removes direct mentions
# Core implementation does this for github only
#
module Dependabot
  class PullRequestCreator
    class MessageBuilder
      class MetadataPresenter
        # :reek:BooleanParameter
        def sanitize_links_and_mentions(text, unsafe: false)
          LinkAndMentionSanitizer
            .new(github_redirection_service: github_redirection_service)
            .sanitize_links_and_mentions(text: text, unsafe: unsafe)
        end
      end
    end
  end
end
