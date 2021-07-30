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
  end

  Healthcheck.routes(self)
end
