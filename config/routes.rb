ActionController::Routing::Routes.draw do |map|
  map.about 'about', :controller => 'info', :action => 'about'
  
  map.resources :comments
  map.resources :tags
  map.resources :episodes, :collection => { :recent => :get }
  
  map.root :recent_episodes
end
