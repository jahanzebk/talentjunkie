class SessionsController < PublicController

  skip_before_filter :redirect_if_session_exists
  
  def create
    @user_session = UserSession.new(params[:user_session])
    begin
      @user_session.save!
      redirect_to :my_profile
    rescue
      # raise
      redirect_to :welcome
    end
  end
  
  def destroy
    begin
      current_user_session = UserSession.find
      current_user_session.destroy if current_user_session.present?
    rescue
      # raise
    end
    redirect_to :welcome
  end
end
