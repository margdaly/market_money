Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v0 do
      resources :markets, only: %i[index show search] do
        resources :vendors, only: [:index], controller: 'markets/vendors'
        get 'search', to: 'markets#search'
        get 'nearest_atms', to: 'market/atms#index'
      end

      resources :vendors, only: %i[show create update destroy]
      resources :market_vendors, only: %i[create]
      resource :market_vendors, only: %i[destroy]
    end
  end
end
