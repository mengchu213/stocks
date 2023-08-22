Rails.application.routes.draw do
  
  resources :portfolios
  resources :stocks, param: :symbol do
    resources :transactions
  end
  resources :users, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :transactions, only: [:index]
    collection do
      get :approvals
    end
    member do
      get :approve
    end
  end
  
  get "/profile", to: "home#profile", as: "profile"
  resources :home
  get  "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  get  "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  resources :sessions, only: [:index, :show, :destroy]
  resource  :password, only: [:edit, :update]
  namespace :identity do
    resource :email,              only: [:edit, :update]
    resource :email_verification, only: [:show, :create]
    resource :password_reset,     only: [:new, :edit, :create, :update]
  end
  root "home#landing"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
