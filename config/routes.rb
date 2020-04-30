# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/login', to: 'authentication#login'

      resources :clients, only: :create do
        get :my_indications, on: :collection
      end
      resources :bank_accounts, only: :create
    end
  end
end
