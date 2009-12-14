class SessionsController < PublicController

  skip_before_filter :redirect_if_session_exists
  
  def create
    begin
      @request_path = session[:request_path]
      reset_session
      @session_user = User.authenticate(params[:primary_email], params[:password])
      
      if @session_user
        session[:user] = @session_user.id 
        redirect_to @request_path.present? ? @request_path : my_profile_path and return true
      end
    rescue SecurityError => e
      flash[:error] = 'The email address or password you provided does not match our records. Please provide a valid email and password.'
    rescue
      raise
    end
    
    redirect_to welcome_path
  end
  
  def destroy
    @session_user = nil
    session[:user] = nil
    reset_session
    redirect_to welcome_path
  end
  
  def __create
    @user_session = UserSession.new(params[:user_session])
    begin
      @user_session.save!
      redirect_to :my_profile
    rescue
      # raise
      redirect_to :welcome
    end
  end
  
  def __destroy
    begin
      current_user_session = UserSession.find
      current_user_session.destroy if current_user_session.present?
    rescue
      # raise
    end
    redirect_to :welcome
  end
end
