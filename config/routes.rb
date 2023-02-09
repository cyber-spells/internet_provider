Rails.application.routes.draw do
  resources :complaints, only: [:new,:create,:show,:index]
  root to:'pages#home'
  devise_for :employees, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
