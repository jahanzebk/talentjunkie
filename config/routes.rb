ActionController::Routing::Routes.draw do |map|

  # admin
  map.namespace(:admin) do |admin|
    admin.resources :communities
    admin.resources :organizations
    admin.resources :industries
    admin.resources :external_feeds do |external_feed|
      external_feed.resources :entries, :controller => "external_feed_entries", :member => { :review => :post, :unreview => :post, :publish_to_all => :put } do |entry|
        entry.resources :organizations, :controller => :external_feed_entry_organizations, :member => { :publish => :post }
        entry.resources :communities, :controller => :external_feed_entry_communities, :member => { :publish => :post }
      end
    end
    admin.resources :users
  end
  
  map.namespace(:api) do |api|
    api.resources :profiles
  end
  
  map.namespace(:developers) do |api|
    api.resources :docs
  end

  map.namespace(:manage) do |manage|
    manage.root :controller => "openings", :action => "index"
    manage.resources :openings do |opening|
      opening.resources :applications, :controller => :job_applications, :except => :show
      opening.resources :stages, :controller => :job_application_stages
    end
    manage.resources :my_job_applications
  end
  
  # public
  map.resources :signup
  map.resources :signup_fb
  
  # authd
  map.resources :ads
  
  map.resources :organizations, :member => { :follow => :post, :unfollow => :post, :newsfeed => :get } do |organization|
    organization.resources :openings, :only => :show  do |opening|
      opening.resources :applications, :controller => :job_applications, :only => :create
    end
    
    organization.resources :positions do |position|
      position.resources :contracts
    end
    organization.resources :logos, :controller => "organization_logos"
    organization.resources :offices, :controller => "organization_offices"
  end
  
  map.resources :users, :as => "people", :member => { :lock => :put, :unlock => :put, :directory => :get, :update_handle => :put, :update_password => :put, :new_email_profile => :get, :send_email_profile => :post, :settings => :get, :newsfeed => :get, :organizations => :get, :follow => :post, :unfollow => :post, :profile_stats => :get } do |user|
    user.resources :contracts
    user.resources :diplomas
    user.resources :photos, :controller => "user_photos"
    user.resources :invitations
    user.resources :interests
    user.resources :notes
  end
  
  map.resources :communities, :member => { :jobs => :get, :newsfeed => :get, :join => :post }
  
  map.connect "/reset_password", :controller => "users", :action => "reset_password"
  map.connect "/forgot_password", :controller => "users", :action => "forgot_password"
  map.connect "/people/:user_id/charts/:action", :controller => "charts"
  map.connect "/people/:user_id/openings/:id", :controller => "users", :action => "openings"
  
  map.connect "/jobs", :controller => "openings", :action => "index"
  map.connect "/please_login", :controller => "public_pages", :action => "please_login"
  
  map.resources :sessions
  map.resources :imports, :as => "import_profile"
  
  map.connect "/helpers/:action", :controller => "helpers"
  
  map.connect "/crunchbase_permalinks/:id/:action", :controller => "crunchbase_permalinks"
  
  map.connect "/sessions_fb/create", :controller => "sessions_fb", :action => 'create'
  
  map.connect "/search_remote/:action", :controller => "search_remote"
  map.connect "/autocomplete/:action", :controller => "autocomplete"

  map.login "login", :controller => "sessions", :action => "new"
  map.logout "logout", :controller => "sessions", :action => "destroy"

  map.dashboard "/dashboard", :controller => "users", :action => "dashboard" 
  map.connect "/vision", :controller => "public_pages", :action => "vision"
  map.welcome '', :controller => 'public_pages'
end
