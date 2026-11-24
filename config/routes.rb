# frozen_string_literal: true
# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get "login", to: "login#index"
  post "authenticate", to: "login#authenticate"
  post "logout", to: "login#logout"

  resources :players

  resources :tournaments do
    resources :tournament_players, only: %i[new create]
    member do
      post :search_players
      post :show_players
      post :show_search
      post :archon_csv
      get :unconfirmed_sheet
    end
  end

  resources :tournament_players, only: [:destroy] do
    member do
      patch :toggle_confirm
      post :edit_decklist
      patch :update_decklist
      post :resend_link
    end
  end

  resources :registrations, only: %i[show edit update destroy] do
    member do
      post :search
    end
  end

  resources :decklists, only: %i[index show] do
    member do
      get :tournament_index
      post :download
      post :download_combined
      post :download_zip
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  root "tournaments#index"
end
