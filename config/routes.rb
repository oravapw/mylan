# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  resources :registereds, only: [:index, :edit, :update, :destroy]

  # Defines the root path route ("/")
  root "overview#index"
end
