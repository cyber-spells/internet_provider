Rails.application.routes.draw do
  devise_for :consumers
  resources :complaints, only: [:new, :create, :show, :index]
  root to: 'consumers#show'
  devise_for :employees, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :change_tariff_requests, only: [:create]
end
