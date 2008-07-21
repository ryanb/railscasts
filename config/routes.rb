ActionController::Routing::Routes.draw do |map|
  map.about 'about', :controller => 'info', :action => 'about'
  map.contest 'contest', :controller => 'info', :action => 'contest'
  
  map.login 'login', :controller => 'sessions', :action => 'new'
  map.login 'logout', :controller => 'sessions', :action => 'destroy'
  
  map.resources :comments
  map.resources :tags
  map.resources :episodes, :collection => { :recent => :get }
  map.resources :sessions
  
  map.root :recent_episodes
end
