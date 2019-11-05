Rails.application.routes.draw do
  root to: "posts#index"

  resources :categories, except: :destroy

  resources :posts, except: :destroy do
    resources :comments, only: :create
  end

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
end
