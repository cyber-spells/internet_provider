Rails.application.routes.draw do
  devise_for :consumers, controllers: { sessions: 'consumers/sessions', registrations: 'consumers/registrations' }

  get "admin/consumers/get_all_consumers", as: "get_all_consumers"

  post 'consumers/:id/refill', to: 'consumers#refill', as: 'consumer_refill'

  post 'consumers/:id/update_balance', to: 'consumers#update_balance', as: 'consumer_update_balance'

  resources :complaints, only: [:new, :create]
  get 'get_complaint/:id', to: 'complaints#get_complaint', as: 'get_complaint'

  get 'get_payment/:id', to: 'payments#get_payment', as: 'get_payment'

  get 'download_payment/:id', to: 'payments#download_payment', as: 'download_payment'

  post 'consumers/:id/view_notifications', to: 'consumers#view_notifications', as: 'consumer_view_notifications'

  root to: 'consumers#show'

  devise_for :employees, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  resources :change_tariff_requests, only: [:create]
end
