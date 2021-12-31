Rails.application.routes.draw do
  devise_for :users

  get 'tags/:tag', to: 'posts#index', as: :tag

  resources :posts
  resources :users

  get 'posts/index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'posts#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
