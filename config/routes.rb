# frozen_string_literal: true

Rails.application.routes.draw do
  resources :stories do
    resources :comments, module: :stories, only: :create
  end

  resources :comments, only: %i[show edit update destroy] do
    resources :comments, module: :comments, only: :create
  end

  get 'home/index'

  devise_for :users, controllers: { registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'home#index'
end
