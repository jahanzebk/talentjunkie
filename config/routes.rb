ActionController::Routing::Routes.draw do |map|
  
  # public
  
  map.resources :signup
  
  
  # authd
  
  map.resources :ads
  
  map.resources :organizations do |organization|
    organization.resources :openings
    organization.resources :positions do |position|
      position.resources :contracts do |contract|
        contract.resources :job_applications
      end
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
  
  map.my_profile "my/profile", :controller => "users", :action => "profile"
  map.my_organizations "my/organizations", :controller => "users", :action => "organizations"
  
  map.connect "profile/:id", :controller => "users", :action => "profile"
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.welcome '', :controller => 'public_pages'
  
end
