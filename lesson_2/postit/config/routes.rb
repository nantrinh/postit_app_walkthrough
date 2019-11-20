Rails.application.routes.draw do
  root to: "posts#index"

  resources :categories, except: :destroy

  resources :posts, except: :destroy do
    resources :comments, only: :create
  end
end
