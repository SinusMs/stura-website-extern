Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "application#index"

  get "/backend", to: "sessions#show", as: "backend_root"

  resources :users
  put "users/:id/reset_password_request", to: "users#reset_password_request", as: :reset_password_request
  get "forgot_password", to: "users#forgot_password", as: :forgot_password
  post "forgot_password", to: "users#submit_forgot_password"
  get "users/reset_password/:code", to: "users#reset_password", as: :reset_password
  patch "users/reset_password/:code", to: "users#submit_reset_password"

  resources :contact_email_addresses
  resources :events
  resources :articles do
    collection do
      get "category/:article_category_id", to: "articles#category", as: "article_category"
    end
  end
  resources :article_categories
  resource :settings, only: [ :edit, :update ]

  get "/login", to: "sessions#login", as: "login"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#logout", as: "logout"
  post "/logout", to: "sessions#logout"

  resources :contact_forms, only: [ :index, :create ], path: "contact", path_names: { index: "" }
end
