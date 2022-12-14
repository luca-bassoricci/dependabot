# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  mount Yabeda::Prometheus::Exporter => "/metrics" if AppConfig.metrics

  root "dependabot#index"
  put "/jobs/:id/execute", to: "job#execute", as: "job_execute"
  put "/projects/:id/update", to: "project#update", as: "project_update"

  namespace :api, defaults: { format: :json } do
    resources :hooks, only: [:create]
    resources :notify_release, only: [:create]
    resources :projects, only: %i[index show create update destroy]
    scope :projects do
      resources :registration, only: [:create] if AppConfig.project_registration == "system_hook"
    end
  end

  Healthcheck.routes(self)
end
