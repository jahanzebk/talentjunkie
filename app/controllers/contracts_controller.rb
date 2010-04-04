class ContractsController < ApplicationController
  
  def new
    @html_content = render_to_string :partial => "/contracts/new.haml"
    respond_to do |format|
      format.js { render :template => "/common/new.rjs"}
    end
  end
  
  def create
    begin
      ActiveRecord::Base.transaction do
        @contract = Contract.new(params[:contract])
        @contract.user_id = current_user.id
        @contract.save!
        
        FollowingOrganization.create!({:user_id => current_user.id, :organization_id => @contract.position.organization.id}) unless current_user.is_following_organization?(@contract.position.organization)
        
        step = AchievementStep.find(2)
        current_user.steps << step unless current_user.steps.include?(step)
      
        Events::UpdatedProfile.create!({:subject_id => current_user.id})
      end
      
      render :json => {:url => person_path(current_user)}.to_json, :status => 201
    rescue
      render :json => collect_errors_for(@contract).to_json, :status => 406
    end
  end
  
  def edit
    @contract = Contract.find(params[:id])
    @position = @contract.position
    @organization = @position.organization
    @html_content = render_to_string :partial => "/contracts/edit.haml"
    
    respond_to do |format|
      format.js { render :template => "/common/edit.rjs"}
    end
  end  

  def update
    begin
      ActiveRecord::Base.transaction do
        @contract = Contract.find(params[:id])
        @contract.update_attributes(params[:contract])
        @contract.save!
        
        Events::UpdatedProfile.create!({:subject_id => current_user.id})
      end
      
      render :json => {:url => person_path(current_user)}.to_json, :status => 201
    rescue
      render :json => collect_errors_for(@contract, @contract.position, @contract.position.organization).to_json, :status => 406
    end
  end
  
  def destroy
    current_user.contracts.find(params[:id]).destroy
    redirect_to person_path(current_user)
  end
  
end