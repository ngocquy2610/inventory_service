Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      get "ping", to: "pings#show"
      post "ping", to: "pings#calculate"
      get "ingredients", to: "ingredients#index"
    end
  end
end
