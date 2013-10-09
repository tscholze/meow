Cats::Application.routes.draw do
  
  constraints :subdomain => /^m(\.\w+)?$/ do
    namespace :mobile, :path => '/' do
      get '/' => 'cats#index'
      get '/cats/:id' => 'cats#show', :as => :cat
    end
  end
  
  root :to => 'cats#index'
  
  # cats
  get '/cats/random' => 'cats#random', :as => :random_cat
  get '/cats/:id' => 'cats#show', :as => :cat
  get '/feed' => 'cats#feed', :as => :feed
  delete '/cats/:id' => 'cats#destroy'
  
  match '/users/login', :as => :user_login, :via => [:get, :post]
  match '/users/logout', :as => :user_logout, :via => [:get, :post]
  
  resources :users
  
  # dropbox oauth
  get '/dropbox/associate', :as => :dropbox_associate
  get '/dropbox/callback', :as => :dropbox_callback
  
end
