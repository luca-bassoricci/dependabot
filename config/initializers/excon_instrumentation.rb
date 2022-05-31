# frozen_string_literal: true

ActiveSupport::Notifications.subscribe(/excon.request/) do |_name, _start, _finish, _id, payload|
  method = payload[:method]
  url = url_from_payload(payload)

  ApplicationHelper.log(:debug, "Performing http :#{method} request to '#{url}'", "core")
end

ActiveSupport::Notifications.subscribe(/excon.response/) do |_name, _start, _finish, _id, payload|
  url = url_from_payload(payload)

  ApplicationHelper.log(:debug, "Received response from '#{url}', status: #{payload[:status]}", "core")
end

# Get url from payload
#
# @param [Hash] payload
# @return [String]
def url_from_payload(payload)
  scheme = payload[:scheme] ? "#{payload[:scheme]}://" : ""
  "#{scheme}#{payload[:host]}:#{payload[:port]}#{payload[:path]}"
end
