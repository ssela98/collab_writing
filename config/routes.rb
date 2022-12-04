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
  resources :tags, only: %i[new show create]
  resources :tags, only: :destroy, param: :name

  get 'home/index'

  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users, only: :show, param: :username do
    member do
      get :stories
      get :comments
      get :favourites
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'home#index'
end
