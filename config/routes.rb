Rails.application.routes.draw do
  devise_for :consumers

  get "admin/consumers/get_all_consumers", as: "get_all_consumers"

  post 'consumers/:id/refill', to: 'consumers#refill', as: 'consumer_refill'

  post 'consumers/:id/update_balance', to: 'consumers#update_balance', as: 'consumer_update_balance'

  resources :complaints, only: [:new, :create, :show]

  root to: 'consumers#show'

  devise_for :employees, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  resources :change_tariff_requests, only: [:create]
end
