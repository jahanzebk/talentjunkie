class Api::ProfilesController < ApplicationController

  around_filter :catch_api_errors
  
  def catch_api_errors
    begin
      yield
    rescue
      raise
      render :xml => "<error></error>", :status => 404
    end
  end
  
  def show
    begin
      @user = params[:id] ? User.find(params[:id]) : current_user
    rescue
      @user = User.find_by_handle(params[:id])
    end

    respond_to do |format|
      format.xml do
        render :layout => false
      end
    end
  end
  
end
