ActionController::Routing::Routes.draw do |map|

  # admin
  map.namespace(:admin) do |admin|
    admin.resources :organizations
    admin.resources :industries
  end
  
  map.namespace(:api) do |api|
    api.resources :profiles
  end
  
  map.namespace(:developers) do |api|
    api.resources :docs
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
    organization.resources :logos, :controller => "organization_logos"
  end
  
  map.resources :users, :as => "people", :member => { :newsfeed => :get, :organizations => :get, :follow => :post, :unfollow => :post } do |user|
    user.resources :contracts
    user.resources :diplomas
    user.resources :photos, :controller => "user_photos"
    user.resources :invitations
    user.resources :interests
    user.resources :notes
  end
  
  map.resources :sessions
  map.resources :imports
  
  
  map.connect "/crunchbase_permalinks/:id/:action", :controller => "crunchbase_permalinks"
  
  map.connect "/sessions_fb/create", :controller => "sessions_fb", :action => 'create'
  
  map.connect "/search_remote/:action", :controller => "search_remote"
  map.connect "/autocomplete/:action", :controller => "autocomplete"

  map.login "login", :controller => "sessions", :action => "new"
  map.logout "logout", :controller => "sessions", :action => "destroy"

  map.dashboard "/dashboard", :controller => "users", :action => "dashboard"  
  map.welcome '', :controller => 'public_pages'
  
end
