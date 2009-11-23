class UserPhotosController < ApplicationController
  
  def new
    @user = current_user
    @html_content = render_to_string :partial => "/users/photo.haml"
    respond_to do |format|
      format.js {render :template => "/users/photo.rjs"}
    end
  end
  
  def create
    photo = UserPhoto.new(params[:user_photo])
    photo.uploaded_on = Time.now
    photo.uploaded_by_user_id = current_user.id
    
    flash[:success] = 'Photo was successfully uploaded' if photo.save!
  
    current_user.photo.destroy if current_user.photo
    current_user.photo = photo
    
    redirect_to :my_profile
  end
end