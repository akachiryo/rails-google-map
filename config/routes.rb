Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get 'maps/search', to: 'maps#search', as: 'search_maps'
  get 'maps/result', to: 'maps#result'
  resources :maps, except: [:show]
end
