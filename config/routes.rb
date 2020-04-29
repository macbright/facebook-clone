Rails.application.routes.draw do
  root to: 'posts#index'
  
  mount ActionCable.server => '/cable'
  
  get "/friends", to: 'home#friends'
  
  post 'comments/create'
  get 'comments/show'
  get 'comments/edit'
  post 'comments/update'
  delete "/delete_comment", to: "comments#destroy"
  
  get 'users/index' => 'users#index'
  get 'home' => 'home#index'
  get 'posts' => 'posts#index'
  devise_for :users, path: '', path_names: { 
                                          sign_in: 'login', 
                                          sign_out: 'logout', 
                                          password: 'secret', 
                                          confirmation: 'verification', 
                                          unlock: 'unblock', 
                                          registration: 'signup', 
                                          sign_up: 'new' },
              controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  
  delete "/delete_post", to: "posts#destroy"
  
  post "likes/create"
  delete "likes/destroy"
  
  post '/create_friend', to: "friendships#create"
  delete "/delete_friend", to: "friendships#destroy"
  patch "/confirm_friend", to: "friendships#confirm"
  delete "/cancel_request", to: "friendships#cancel"
   delete "/ignore_request", to: "friendships#ignore"
  get 'friends', to: 'home#friends'


  resource :post
  resource :comments
  resource :likes
  resource :user
  resource :friendships
  resources :messages, only: [:create]

  
end
