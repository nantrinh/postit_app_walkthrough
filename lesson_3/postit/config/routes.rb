Rails.application.routes.draw do
  root to: 'posts#index'

  resources :categories, except: :destroy

  resources :posts, except: :destroy do
    member do
      post 'vote'
    end

    resources :comments, only: :create
  end

  resources :users, only: [:show, :create, :edit, :update]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/register', to: 'users#new'
end
