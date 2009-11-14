class SessionsController < ApplicationController
  
  layout "public_pages"
  
  def new
    @title = 'Login'
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to home_url
    else
      render :action => 'new'
    end
  end
  
  def destroy
    begin
      @user_session = UserSession.find(params[:id])
      @user_session.destroy
    rescue
    end
    redirect_to :welcome
  end
end
