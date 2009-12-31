class InterestsController < ApplicationController
  
  def new
    @html_content = render_to_string :partial => "/interests/new.haml"
    respond_to do |format|
      format.js
    end
  end
  
  def create
    begin
      ActiveRecord::Base.transaction do
        @interest = Interest.new(params[:interest])
        @interest.user_id = current_user.id
        @interest.save!
      end
    
      render :json => {:url => person_path(current_user)}.to_json, :status => 201
    rescue
      render :json => collect_errors_for(@interest).to_json, :status => 406
    end
  end
  
  def edit
    @interest = current_user.interests.find(params[:id])
    @html_content = render_to_string :partial => "/interests/edit.haml"
    respond_to do |format|
      format.js
    end
  end  

  def update
    begin
      ActiveRecord::Base.transaction do
        @interest = current_user.interests.find(params[:id])
        @interest.update_attributes(params[:interest])
        @interest.save!
      end
      
      Events::UpdatedProfile.create!({:subject_id => current_user.id})
      
      render :json => {:url => person_path(current_user)}.to_json, :status => 201
    rescue
      raise
      render :json => collect_errors_for(@interest).to_json, :status => 406
    end
  end
  
  
  def destroy
    current_user.interests.find(params[:id]).destroy
    redirect_to my_profile_path
  end
  
end
