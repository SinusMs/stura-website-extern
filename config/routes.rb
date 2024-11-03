Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "sessions#show"

  get "/backend", to: "sessions#show", as: "backend_root"

  resources :users, only: [ :new, :create, :edit, :update, :show, :destroy, :index ]
  resources :contact_email_addresses

  get "/login", to: "sessions#login", as: "login"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#logout", as: "logout"
  post "/logout", to: "sessions#logout"

  get "/contact", to: "contact_forms#index"
  post "/contact", to: "contact_forms#post"
end
