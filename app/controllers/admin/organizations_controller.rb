class Admin::OrganizationsController < AdminController
  
  def index
    @title = "admin"
    @starting_with = params[:q] ? params[:q] : 'a'
    @organizations = Organization.all(:conditions => "name LIKE '#{@starting_with}%'", :order => "name ASC")
  end
  
end