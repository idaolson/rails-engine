Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      # section two
      get '/merchants/find', to: 'merchants#find'
      get '/items/find_all', to: 'items#find_all'

      # section three
      get '/revenue/merchants/:id', to: 'revenue#total_revenue_merchant'
      get '/merchants/most_items', to: 'merchants#most_items_sold'
      get '/revenue/items', to: 'revenue#most_revenue_items'

      # section one
      resources :merchants, only: %i[index show] do
        resources :items, only: :index
      end
      resources :items, only: %i[index show create update destroy] do
        get '/merchant', to: 'merchants#show'
      end
    end
  end
end
