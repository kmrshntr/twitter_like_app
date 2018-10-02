Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  #static_pages
  root   'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  #users
  get    '/signup',  to: 'users#new'
  resources :users do
    member do
      get :following, :followers
    end
  end
  #sessions
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  #accountactivations
  resources :accout_activations, only: [:edit]
  #password_resets
  resources :password_resets,    only: [:new, :create, :edit, :update]
  #microposts
  resources :microposts,         only: [:create, :destroy]
  #relationships
  resources :relationships,      only: [:create, :destroy]
end
