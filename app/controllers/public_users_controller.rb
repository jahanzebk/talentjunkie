class PublicUsersController < ApplicationController
  
  layout "public_pages"
  
  def index
    @title = 'Sign up'
    render :new
  end
  
end