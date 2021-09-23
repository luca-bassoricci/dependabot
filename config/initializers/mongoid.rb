# frozen_string_literal: true

rails_env = ENV["RAILS_ENV"] || "development"
default_config = {
  clients: {
    default: {
      hosts: [ENV["MONGODB_URL"] || "localhost:27017"],
      database: ENV["MONGODB_DATABASE"] || "dependabot_gitlab_#{rails_env}",
      options: {
        server_selection_timeout: 1,
        connect_timeout: 1,
        retry_writes: ENV["MONGODB_RETRY_WRITES"] || "true"
      }
    }
  }
}

configuration = {
  "development" => default_config,
  "test" => default_config,
  "production" => if ENV["MONGODB_URI"]
                    { clients: { default: { uri: ENV["MONGODB_URI"] } } }
                  else
                    {
                      **default_config.tap do |config|
                        config.dig(:clients, :default)[:options] = {
                          server_selection_timeout: 5,
                          connect_timeout: 5,
                          user: ENV["MONGODB_USER"],
                          password: ENV["MONGODB_PASSWORD"],
                          retry_writes: ENV["MONGODB_RETRY_WRITES"] || "true"
                        }
                      end
                    }
                  end
}

Mongoid.configure do |config|
  config.app_name = "DependabotGitlab"
  config.load_configuration(configuration[rails_env])
end
