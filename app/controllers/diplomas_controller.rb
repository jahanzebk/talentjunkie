class DiplomasController < ApplicationController
  
  def new
    @html_content = render_to_string :partial => "/diplomas/new.haml"
    respond_to do |format|
      format.js { render :template => "/common/new.rjs"}
    end
  end
  
  def create
    begin
      ActiveRecord::Base.transaction do
        @diploma = Diploma.new(params[:diploma])
        @diploma.user_id = current_user.id
        @diploma.save!
        
        step = AchievementStep.find(3)
        current_user.steps << step unless current_user.steps.include?(step)
      end
      
      render :json => {:url => person_path(current_user)}.to_json, :status => 201
    rescue
      render :json => collect_errors_for(@diploma, @diploma.degree, @diploma.degree.organization).to_json, :status => 406
    end
  end
  
  def edit
    @diploma = Diploma.find(params[:id])
    @html_content = render_to_string :partial => "/diplomas/edit.haml"
    respond_to do |format|
      format.js { render :template => "/common/edit.rjs"}
    end
  end
  
  def update
    begin
      ActiveRecord::Base.transaction do
        @diploma = Diploma.find(params[:id])
        @diploma.update_attributes(params[:diploma])
        @diploma.save!
      end
      
      render :json => {:url => person_path(current_user)}.to_json, :status => 201
    rescue
      render :json => collect_errors_for(@diploma, @diploma.degree, @diploma.degree.organization).to_json, :status => 406
    end
  end
  
  def destroy
    current_user.diplomas.find(params[:id]).destroy
    redirect_to person_path(current_user)
  end
  
end