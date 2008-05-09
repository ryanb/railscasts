ActionController::Routing::Routes.draw do |map|
  map.resources :episodes
  map.root :controller => 'episodes'
end
