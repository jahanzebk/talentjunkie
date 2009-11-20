class SignupController < PublicController
  
  def create
    @user = User.new(params[:user])
    respond_to do |format|
      begin
        @user.save! # @user.save_without_session_maintenance
        format.json{ render :json => :ok }
      rescue
        format.json{ render :json => @user.errors.to_json, :status => 406 }
      end
    end
    
  end
  
end