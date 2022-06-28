# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get "login", to: "login#index"
  post "authenticate", to: "login#authenticate"
  post "logout", to: "login#logout"

  resources :registereds, only: [:index, :edit, :update, :destroy]
  resources :players, except: [:show]
  resources :changelogs, only: [:index]
  resources :tournaments do
    resources :tournament_players, shallow: true
  end

  root "overview#index"
end
