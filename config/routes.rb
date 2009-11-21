ActionController::Routing::Routes.draw do |map|
  map.resources :spam_questions

  map.resources :spam_checks

  map.with_options :controller => 'info' do |info|
    info.about 'about', :action => 'about'
    info.contest 'contest', :action => 'contest'
    info.feeds 'feeds', :action => 'feeds'
  end
  
  map.login 'login', :controller => 'sessions', :action => 'new'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'
  
  map.resources :sponsors
  map.resources :comments
  map.resources :tags
  map.resources :episodes, :collection => { :archive => :get }
  map.resources :sessions
  map.resources :spam_reports, :member => { :confirm => :post }
  
  map.root :episodes
end
