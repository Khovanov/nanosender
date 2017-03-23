Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :messages, only: [:single, :batch] do
        post :single, on: :collection
        post :batch, on: :collection
      end
      resources :users, only: :index
    end
  end
end
