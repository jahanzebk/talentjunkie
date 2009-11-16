class PublicPagesController < PublicController
  
  def index
    @user_session = UserSession.new
  end
  
end