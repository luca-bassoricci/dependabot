# frozen_string_literal: true

rails_env = ENV["RAILS_ENV"] || "development"
mongoid_config = {
  hosts: [ENV["MONGODB_URL"] || "localhost:27017"],
  database: ENV["MONGODB_DATABASE"] || "dependabot_gitlab_#{rails_env}",
  options: {
    server_selection_timeout: 1,
    connect_timeout: 1,
    retry_writes: ENV["MONGODB_RETRY_WRITES"] || "true"
  }
}

if rails_env == "production"
  mongoid_config[:options].tap do |options|
    options[:server_selection_timeout] = 5
    options[:connect_timeout] = 5
    options[:user] = ENV["MONGODB_USER"]
    options[:password] = ENV["MONGODB_PASSWORD"]
  end
end

Mongoid.configure do |config|
  config.app_name = "DependabotGitlab"
  config.clients.default = ENV["MONGODB_URI"] ? { uri: ENV["MONGODB_URI"] } : mongoid_config
end
