Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resource :users, only: [:create]
  post "/login", to: "auth#login"
  get "/auto_login", to: "auth#auto_login"
  get "/user_is_authed", to: "auth#user_is_authed"
  post "/password_reset", to: "password_reset#create"
  put "/password_reset", to: "password_reset#update"

  namespace :v1 do
    resources :users do
      resources :social_accounts
      resources :posts do
        resources :comments
        resource :metrics
      end
      resources :notifications, only: [:index, :update]
    end

    resources :social_accounts, only: [:index, :create, :update, :destroy]
    resources :posts, only: [:index, :create, :update, :destroy]
    resources :comments, only: [:index, :create, :update, :destroy]
    resources :metrics, only: [:index]
    resources :notifications, only: [:index, :update]
  end
end
