# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

task default: :test

desc "Run unit tests"
task test: :environment do
  sh("bundle exec rspec --tag ~system")
end

desc "Run system tests"
task system_test: :environment do
  sh("bundle exec rspec --tag system")
end
