# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'

  resources :crud, only: [] do
    collection do
      scope module: :crud do
        resources :users
        resources :teams
      end
    end
  end
end
