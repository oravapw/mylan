# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get "login", to: "login#index"
  post "authenticate", to: "login#authenticate"
  post "logout", to: "login#logout"

  resources :registereds, only: [:index, :edit, :update, :destroy]

  # Defines the root path route ("/")
  root "overview#index"
end
