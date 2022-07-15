# frozen_string_literal: true

default_config = lambda do |environment|
  {
    clients: {
      default: {
        hosts: [ENV["MONGODB_URL"] || "localhost:27017"],
        database: ENV["MONGODB_DATABASE"] || "dependabot_gitlab_#{environment}",
        options: {
          server_selection_timeout: 1,
          connect_timeout: 1,
          user: ENV["MONGODB_USER"],
          password: ENV["MONGODB_PASSWORD"],
          retry_writes: ENV["MONGODB_RETRY_WRITES"] || "true"
        }
      }
    }
  }
end

configuration = {
  "development" => default_config.call("development"),
  "test" => default_config.call("test"),
  "production" => if ENV["MONGODB_URI"]
                    { clients: { default: { uri: ENV["MONGODB_URI"] } } }
                  else
                    default_config.call("production").tap do |config|
                      config.dig(:clients, :default)[:options].tap do |options|
                        options[:server_selection_timeout] = 5
                        options[:connect_timeout] = 5
                      end
                    end
                  end
}

Mongoid.configure do |config|
  config.app_name = "DependabotGitlab"
  config.load_configuration(configuration[ENV["RAILS_ENV"] || "development"])
end
