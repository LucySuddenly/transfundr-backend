Rails.application.routes.draw do
  resources :profiles
  resources :donations
  resources :beacons
  resources :users
  post '/auth', to: "auth#create"
  get '/getprofilebyuserid/:id',  to: "profile#get_profile_by_user_id"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
