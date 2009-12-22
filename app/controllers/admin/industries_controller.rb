class Admin::IndustriesController < AdminController
  
  def index
    @industries = Industry.all
  end
  
end