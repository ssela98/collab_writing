# frozen_string_literal: true

Rails.application.routes.draw do
  resources :stories, except: :index do
    member do
      patch :vote
    end
    resources :comments, module: :stories, except: %i[index new] do
      member do
        patch :vote
      end
    end
  end
  resources :pins, only: %i[create update destroy]

  get 'home/index'

  devise_for :users, controllers: { registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'home#index'
end
