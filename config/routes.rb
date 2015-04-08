Rails.application.routes.draw do
  resources :items
  resources :categories, only: [] do
    get :sub_categories
  end
  root 'items#index'
end
