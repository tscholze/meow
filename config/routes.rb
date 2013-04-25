Cats::Application.routes.draw do
  root :to => 'cats#index'
  match '/cats/random' => 'cats#random', :as => :random_cat
  match '/cats/:id' => 'cats#show', :as => :cat
end