class PublicUsersController < PublicController
  
  layout "public_pages"
  
  def index
    @title = 'Sign up'
    render :new
  end
  
end