Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # users
  post "user" => "users#create"
  get "user" => "users#show"
  get "user/list" => "users#list"

  # auth
  post "login" => "sessions#login"

  # conversations
  get "conversations" => "conversations#show"
  post "conversations" => "conversations#create"
  post "conversations/:conversation_uuid/messages" => "messages#create"
  get "conversations/:conversation_uuid/messages" => "messages#show"

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
