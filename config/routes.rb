Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :users, param: :_username do
    member do
      get 'confirm_account'
    end
  end
  post '/auth/login', to: 'authentication#login'
  # get '/*a', to: 'application#not_found'
  resources :workspaces do
    member do
      post 'add_member'
    end
    resources :tasks, only: [:index, :show, :create, :update, :destroy]
  end
  resources :categories, only: [:index, :show, :create, :update, :destroy]
end

