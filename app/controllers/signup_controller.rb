class SignupController < PublicController
  
  skip_before_filter :redirect_if_session_exists  
  
  def create
    @user = User.new(params[:user])
    @user.detail = UserDetail.create!
    begin
      @user.save! # @user.save_without_session_maintenance
      render :json => {:url => "/my/profile"}.to_json, :status => 201
    rescue
      render :json => collect_errors_for(@user).to_json, :status => 406
    end
  end
  
end