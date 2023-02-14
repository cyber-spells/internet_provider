Rails.application.routes.draw do
  devise_for :consumers
  resources :complaints, only: [:new, :create, :show, :index]
  root to: 'consumers#show'
  devise_for :employees, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
