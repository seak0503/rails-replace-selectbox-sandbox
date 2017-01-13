Rails.application.routes.draw do
  resources :items
  resources :categories, only: [] do
    resources :sub_categories, only: :index
  end
  resources :orders

  get 'destgroups_order_categories' => 'order_categories#destgroups_order_categories', as: :destgroups_order_categories
  root 'items#index'
end
