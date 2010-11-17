Railscasts::Application.routes.draw do
  root :to => "episodes#index"
  
  match "about" => "info#about", :as => "about"
  match "contest" => "info#contest", :as => "contest"
  match "feeds" => "info#feeds", :as => "feeds"
  match "give_back" => "info#give_back", :as => "give_back"
  match "login" => "sessions#new", :as => "login"
  match "logout" => "sessions#destroy", :as => "logout"
  
  resources :sponsors
  resources :comments
  resources :tags
  resources :episodes do
    collection do
      get :archive
    end
  end
  resources :sessions
  resources :spam_questions
  resources :spam_checks
  resources :spam_reports do
    member do
      post :confirm
    end
    collection do
      post :confirm
    end
  end
end