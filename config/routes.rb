# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get 'overview/index'

  # Defines the root path route ("/")
  root "overview#index"
end
