ActionController::Routing::Routes.draw do |map|

  # admin
  map.namespace(:admin) do |admin|
    admin.resources :organizations
    admin.resources :industries
  end
  
  map.namespace(:api) do |api|
    api.resources :profiles
  end
  
  # public
  map.resources :signup
  map.resources :signup_fb
  
  # authd
  map.resources :ads
  
  map.resources :organizations, :member => { :follow => :post, :unfollow => :post } do |organization|
    organization.resources :openings do |opening|
      opening.resources :applications, :controller => :job_applications
    end
    organization.resources :positions do |position|
      position.resources :contracts
    end
  end
  
  map.resources :users, :member => { :follow => :post, :unfollow => :post } do |user|
    user.resources :contracts
    user.resources :diplomas
    user.resources :photos, :controller => "user_photos"
    user.resources :invitations
  end
  
  map.resources :sessions
  # map.resources :sessions_fb
  map.resources :imports
  
  
  
  map.connect "/sessions_fb/create", :controller => "sessions_fb", :action => 'create'
  
  map.connect "/search_remote/:action", :controller => "search_remote"
  map.connect "/autocomplete/:action", :controller => "autocomplete"

  map.login "login", :controller => "sessions", :action => "new"
  map.logout "logout", :controller => "sessions", :action => "destroy"
  
  map.my_newsfeed "my/newsfeed", :controller => "users", :action => "newsfeed"
  map.my_profile "my/profile", :controller => "users", :action => "profile"
  map.my_settings "my/settings", :controller => "users", :action => "settings"
  map.my_organizations "my/organizations", :controller => "users", :action => "organizations"
  
  map.connect "public/profile/:id", :controller => "public_users", :action => "public_profile"
  map.connect "profile/:id", :controller => "users", :action => "profile"

  map.welcome '', :controller => 'public_pages'
  
end
