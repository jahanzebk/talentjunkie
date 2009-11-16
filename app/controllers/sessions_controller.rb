class SessionsController < ApplicationController
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to :home
    else
      redirect_to :welcome
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
