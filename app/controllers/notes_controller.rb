class NotesController < ApplicationController
  
  def index
    @user = User.find(params[:user_id])
    render :template => "/users/show/user/notes.haml"
  end
  
  def create
    @user = User.find(params[:user_id])
    @note = Note.new(:user_id => current_user.id, :object_id => @user.id)
    @note.content = params[:notes][:content]
    @note.save!
    
    redirect_to "#{person_path(@user)}/notes"
  end
end