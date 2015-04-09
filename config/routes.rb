Rails.application.routes.draw do
  resources :items
  resources :categories, only: [] do
    resources :sub_categories, only: :index
  end
  root 'items#index'
end
