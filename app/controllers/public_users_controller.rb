class PublicUsersController < PublicController
  
  def index
    @title = 'Sign up'
    render :new
  end
  
  def public_profile
    begin
      begin
        @user = User.find(params[:id])
      rescue
        @user = User.find_by_handle(params[:id])
      end

      @title = @user.full_name
      
      Stats::ProfileView.create!({:user_id => @user.id})
      
      render :template => "/public_users/public_profile.haml"
    rescue
      raise
      render_404
    end
  end
  
end