ActionController::Routing::Routes.draw do |map|
  
  # public
  map.resources :signup
  
  # authd
  map.resources :ads
  
  map.resources :organizations do |organization|
    organization.resources :openings do |opening|
      opening.resources :job_applications
    end
    organization.resources :positions do |position|
      position.resources :contracts
    end
  end
  
  map.resources :users, :member => { :request_connection => :post, :accept_connection => :post } do |user|
    user.resources :contracts
    user.resources :diplomas
  end
  
  map.resources :sessions
  
  map.resources :imports

  map.resources :search_remote, :collection => { :search => :get }  
  map.resources :organizations_remote, :collection => { :search => :get }
  map.resources :positions_remote, :collection => { :search => :get }




  map.login "login", :controller => "sessions", :action => "new"
  map.logout "logout", :controller => "sessions", :action => "destroy"
  
  map.my_newsfeed "my/newsfeed", :controller => "users", :action => "newsfeed"
  map.my_profile "my/profile", :controller => "users", :action => "profile"
  map.my_organizations "my/organizations", :controller => "users", :action => "organizations"
  
  map.connect "profile/:id", :controller => "users", :action => "profile"
  
  map.welcome '', :controller => 'public_pages'
  
end
