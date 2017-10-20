# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'

  resources :crud, only: [] do
    collection do
      scope module: :crud do
        resources :competitions
        resources :events
        resources :users
        resources :teams
        resources :transport_means
        resources :trips
      end
    end
  end
  resources :fans
  resources :events, only: [] do
    collection do
      get :upcoming
      get :all
    end
  end
end
