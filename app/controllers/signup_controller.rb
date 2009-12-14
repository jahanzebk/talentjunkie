class SignupController < PublicController
  
  skip_before_filter :redirect_if_session_exists  
  
  def create
    @user = User.new
    @user.first_name = params[:user][:first_name]
    @user.last_name = params[:user][:last_name]
    @user.primary_email = params[:user][:primary_email]
    @user.password = params[:user][:password]
    
    @user.detail = UserDetail.create!
    begin
      @user.save!
      session[:user] = @user.id
      render :json => {:url => "/my/profile"}.to_json, :status => 201
    rescue
      render :json => collect_errors_for(@user).to_json, :status => 406
    end
  end
  
end