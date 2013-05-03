Cats::Application.routes.draw do
  root :to => 'cats#index'
  get '/cats/random' => 'cats#random', :as => :random_cat
  get '/cats/:id' => 'cats#show', :as => :cat
  get '/feed' => 'cats#feed'
  delete '/cats/:id' => 'cats#destroy'
  match '/users/login', :as => :user_login
  match '/users/logout', :as => :user_logout
  resources :users
end
