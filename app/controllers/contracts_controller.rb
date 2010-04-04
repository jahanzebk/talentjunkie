class ContractsController < ApplicationController
  
  def show
    @contract = Contract.find(params[:id])
    @position = @contract.position
    @organization = @position.organization
  end
  
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
      end
      
      Events::UpdatedProfile.create!({:subject_id => current_user.id})
      render :json => {:url => person_path(current_user)}.to_json, :status => 201
    rescue
      # raise collect_errors_for(@contract, @contract.position, @contract.position.organization).inspect
      render :json => collect_errors_for(@contract, @contract.position, @contract.position.organization).to_json, :status => 406
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
        @organization = Organization.find_or_create_organization_by_name(params[:organization])
        @position = _find_or_create_position(@organization, params[:position])
        @position.organization = @organization
        @position.save!
        
        @contract = Contract.find(params[:contract][:id])
        @contract.position_id = @position.id
        @contract.description = params[:contract][:description]
        @contract.cities_id = params[:contract][:city][:id]
                
        @contract.from = params[:contract][:from_year], params[:contract][:from_month]
        
        if params[:contract][:current].blank?
          @contract.to = params[:contract][:to_year], params[:contract][:to_month]
        else
          @contract.to = nil
        end
        
        
        @contract.save!
      end
      
      Events::UpdatedProfile.create!({:subject_id => current_user.id})
      render :json => {:url => person_path(current_user)}.to_json, :status => 201
    rescue
      render :json => collect_errors_for(@organization, @position, @contract).to_json, :status => 406
    end
  end
  
  def destroy
    current_user.contracts.find(params[:id]).destroy
    redirect_to person_path(current_user)
  end
  
  private
  
  def _find_or_create_position(organization, params)
    @position = Position.find_by_title(params[:title], :conditions => ["organization_id = ?", organization.id])
    unless @position
      @position = Position.new(params)
      @position.save!
      organization.positions << @position
    end
    @position
  end
end