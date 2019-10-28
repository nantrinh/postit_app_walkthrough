Rails.application.routes.draw do
  resources :posts, :categories, except: :destroy
end
