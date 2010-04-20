class Admin::CommunitiesController < AdminController
  
  def index
    @communities = Community.all
  end
  
end