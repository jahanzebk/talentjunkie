class SignupController < ApplicationController
  
  def create
    @user = User.new(params[:user])
    respond_to do |format|
      #if @user.save_without_session_maintenance
      if @user.save
        format.json{ render :json => :ok }
      else
        format.json{ render :json => @user.errors.to_json, :status => 406 }
      end
    end
    
  end
  
end