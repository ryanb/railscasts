ActionController::Routing::Routes.draw do |map|
  map.resources :comments
  map.resources :tags
  map.resources :episodes
  map.root :episodes
end
