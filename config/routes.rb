# frozen_string_literal: true

Rails.application.routes.draw do
  resources :stories, except: %i[index] do
    resources :comments, module: :stories
  end

  get 'home/index'

  devise_for :users, controllers: { registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'home#index'
end
