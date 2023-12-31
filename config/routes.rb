Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'pages#home'

  namespace :api do
    namespace :v1 do
      get 'forecast', to: 'forecasts#show'
    end
  end
end
