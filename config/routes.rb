Rails.application.routes.draw do
  resources :products

  resources :recipes do
    member do
      post :complete, to: 'recipes#complete_recipe'
    end

    collection do
      get :available_recipes
    end
  end

  resources :storage do
    collection do
      post :add_product_to_storage
    end
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
