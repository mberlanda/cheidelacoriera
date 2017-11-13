# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'

  resources :crud, only: [] do
    collection do
      scope module: :crud do
        resources :competitions do
          collection { get :datatable_index }
        end
        resources :events do
          collection { get :datatable_index }
          member { get :datatable_reservations }
        end
        resources :users do
          collection do
            get :datatable_index
            get :approve_all
          end
        end
        resources :teams do
          collection { get :datatable_index }
        end
        resources :transport_means do
          collection { get :datatable_index }
        end
        resources :albums do
          collection { get :datatable_index }
        end
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
      get :reservations
    end
  end
  resources :news
  resources :reservations do
    member do
      get :status
    end
    collection do
      get :user_form
      post :form_create
      get :approve_all
      get :datatable_index
    end
  end
  resources :albums, only: [] do
    collection do
      get :all
    end
  end
end
