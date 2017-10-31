# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'

  resources :crud, only: [] do
    collection do
      scope module: :crud do
        resources :competitions
        resources :events do
          collection { get :datatable_index }
        end
        resources :users do
          collection do
            get :datatable_index
            get :approve_all
          end
        end
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
    member do
      get :details
    end
  end
  resources :news
end
