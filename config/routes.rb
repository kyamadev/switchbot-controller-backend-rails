Rails.application.routes.draw do
  devise_for :users, only: [] # Deviseのデフォルトルートを使用しない
  namespace :api do
    namespace :auth do
      post 'register', to: 'registrations#create'
      post 'login', to: 'sessions#create'
    end

    resources :devices, only: [:index] do
      member do
        post 'control'
      end
    end
  end
end