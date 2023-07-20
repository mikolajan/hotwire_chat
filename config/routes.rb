Rails.application.routes.draw do
  devise_for :users
  resources :rooms, only: %i[index show create new] do
    resources :messages, only: :create
  end
  root "rooms#index"
end
