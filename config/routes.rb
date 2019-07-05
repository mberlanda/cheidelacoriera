# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'

  resources :crud, path: 'admin/', only: [] do
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
            get :mailing_list
          end
        end
        resources :posts do
          collection { get :datatable_index }
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
  resources :events, path: 'trasferta/', only: [] do
    member do
      get :details
      get :reservations
      get :csv_reservations, defaults: { format: :csv }
    end
  end
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

  # resources :news
  get :regolamento, to: 'welcome#regolamento', as: :regolamento
  get 'news-atalantine', to: 'news#index', as: :news_index
  get 'comunicazioni', to: 'posts#all', as: :all_posts
  get 'comunicazioni/archivio', to: 'posts#archivio', as: :archivio_posts
  get 'comunicazioni/:slug', to: 'posts#detail', as: :detail_post
  get 'prossime-trasferte', to: 'events#upcoming', as: :upcoming_events
  get 'tutte-le-trasferte', to: 'events#all', as: :all_events
  get 'foto-trasferte', to: 'albums#all', as: :all_albums
  get 'profilo', to: 'users#profile', as: :profile_users

  get 'sitemap.xml', to: 'sitemap#index', format: :xml, as: :sitemap

  namespace :api, defaults: { format: :json } do
    scope module: :v1 do
      resources :actions, only: [] do
        collection { get :available }
      end
      resources :events, only: [:index] do
        collection { get :upcoming }
      end
    end
  end

  require 'sidekiq/web'
  Sidekiq::Web.set :session_secret, Rails.application.credentials[:secret_key_base]
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
