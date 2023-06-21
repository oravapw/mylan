# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get "login", to: "login#index"
  post "authenticate", to: "login#authenticate"
  post "logout", to: "login#logout"

  resources :players, except: [:show]
  resources :changelogs, only: [:index]
  resources :tournaments do
    resources :tournament_players, only: [:new, :create]
    member do
      post :search_players
      post :show_players
      post :show_search
      post :archon_csv
    end
  end
  resources :tournament_players, only: [:destroy] do
    member do
      patch :toggle_decklist
    end
  end

  root "tournaments#index"
end
