# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  root "dependabot#index"

  mount Sidekiq::Web => "/sidekiq"
  mount Yabeda::Prometheus::Exporter => "/metrics" if AppConfig.metrics

  namespace :api, defaults: { format: :json } do
    resources :hooks, only: [:create]
    resources :project, only: [:create]
    namespace :project do
      resource :add, only: [:create]
      resources :registration, only: [:create] if AppConfig.project_registration == "system_hook"
    end
  end

  Healthcheck.routes(self)
end
