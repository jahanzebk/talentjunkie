class PublicUsersController < PublicController
  
  def index
    @title = 'Sign up'
    render :new
  end
  
  def public_profile
    @user = User.find(params[:id])
    @title = @user.full_name
    render :template => "/public_users/public_profile.haml"
  end
  
end