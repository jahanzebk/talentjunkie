class PublicUsersController < ApplicationController
  
  layout "public_pages"
  
  def index
    @title = 'Sign up'
    render :new
  end
  
  def create
    begin
        @user = User.new(params[:user])
        @user.save!
        flash[:success] = 'Thank you for signing up!'
        redirect_to :login
    rescue 
      index
    end
  end
    
end