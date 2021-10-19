Rails.application.routes.draw do
  resources :recipes, only: :show
  resources :search_recipes, only: :index

  root to: 'search_recipes#index'
end
