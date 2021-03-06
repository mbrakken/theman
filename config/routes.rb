require 'sidekiq/web'
require "admin_constraint"

TheMan::Application.routes.draw do
  root "home#index"

  mount Sidekiq::Web => '/sidekiq', :constraints => AdminConstraint.new

  resources :users, only: [:show, :update, :edit, :index] do
    member do
      get :twitter_email
    end
  end
  resources :payments, only: [:new, :create]
  resources :contributions do
    member do
      get 'claim'
    end
  end
  resources :identities, only: [:destroy, :index]
  resources :sessions, only: [:new, :create, :destroy]
  resources :organizations, only: [:new, :create, :show] do
    collection do
      get :autocomplete_organization_name
    end
  end
  resources :amps, only: [:new, :create]
  resources :events, only: [:new, :show, :create, :edit, :update, :index] do
    member do
      delete :cancel_registration
    end
    collection do
      get :import
    end
    resources :registrations, only: [:new, :create, :index]
  end
  resources :projects, only: [:new, :show, :create, :edit, :update, :index] do
    resources :contributions
  end

  get "/admin" => "admin#index", as: :admin
  namespace :admin do
    resources :event_feeds, only: [:index, :new, :create, :destroy] do
      member do
        put :sync
      end
    end
    resources :events
  end

  get 'tags/:offer_tag', to: 'user#index', as: :offer_tag

  get '/support', to: 'content#support'
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match '/logout', to: 'sessions#destroy', via: [:get, :destroy]

end
