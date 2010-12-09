Railscasts::Application.routes.draw do
  root :to => "episodes#index"

  match "auth/:provider/callback" => "users#create"
  match "about" => "info#about", :as => "about"
  match "contest" => "info#contest", :as => "contest"
  match "feeds" => "info#feeds", :as => "feeds"
  match "give_back" => "info#give_back", :as => "give_back"
  match "login" => redirect("/auth/github"), :as => "login"
  match "logout" => "users#logout", :as => "logout"

  resources :users
  resources :sponsors
  resources :comments
  resources :tags
  resources :episodes do
    collection { get :archive }
  end
  resources :spam_questions
  resources :spam_checks
  resources :spam_reports do
    member { post :confirm }
    collection { post :confirm }
  end
end
