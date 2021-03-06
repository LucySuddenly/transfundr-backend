Rails.application.routes.draw do
  resources :profiles
  resources :donations
  resources :beacons
  resources :users
  post '/auth', to: "auth#create"
  get '/getprofilebyuserid/:id',  to: "profile#get_profile_by_user_id"
  get '/home', to: "beacons#home"
  post '/confirm', to: "donations#confirm"
  get '/notifications', to: "donations#notifications"
  get '/nearlythere', to: "beacons#nearly_there"
  get '/needshelp', to: "beacons#needs_help"
  get '/rankings', to: "users#rankings"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
