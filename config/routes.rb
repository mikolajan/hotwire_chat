Rails.application.routes.draw do
  devise_for :users
  resources :rooms, only: %i[index show create new]
  root "rooms#index"
end
