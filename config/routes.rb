# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  root "dependabot#index"

  mount Sidekiq::Web => "/sidekiq"

  namespace :api, defaults: { format: :json } do
    resources :dependabot, only: [:create]
  end
end
