# frozen_string_literal: true

Dependabot.subscribe(/excon.request/) do |_name, _start, _finish, _id, payload|
  method = payload[:method]
  url = url_from_payload(payload)

  ApplicationHelper.log(:debug, "Performing http :#{method} request to '#{url}'", tags: ["core"])
end

Dependabot.subscribe(/excon.response/) do |_name, _start, _finish, _id, payload|
  url = url_from_payload(payload)

  ApplicationHelper.log(:debug, "Received response from '#{url}', status: #{payload[:status]}", tags: ["core"])
end

Dependabot.subscribe(Dependabot::Notifications::FILE_PARSER_PACKAGE_MANAGER_VERSION_PARSED) do |*args|
  ApplicationHelper.log(:debug, "Package manager parsed version: '#{args.last}'", tags: ["core"])
end

# Get url from payload
#
# @param [Hash] payload
# @return [String]
def url_from_payload(payload)
  scheme = payload[:scheme] ? "#{payload[:scheme]}://" : ""
  "#{scheme}#{payload[:host]}:#{payload[:port]}#{payload[:path]}"
end
