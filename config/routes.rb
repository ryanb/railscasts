ActionController::Routing::Routes.draw do |map|
  map.resources :tags
  map.resources :episodes
  map.root :episodes
end
