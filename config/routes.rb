# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get "login", to: "login#index"
  post "authenticate", to: "login#authenticate"
  post "logout", to: "login#logout"

  resources :players
  resources :changelogs, only: [:index]

  resources :tournaments do
    resources :tournament_players, only: [:new, :create]
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
    end
  end

  resources :registrations, only: [:show, :edit, :update, :destroy] do
    member do
      post :search
    end
  end

  resources :decklists, only: [:index, :show] do
    member do
      get :tournament_index
    end
  end

  root "tournaments#index"
end
