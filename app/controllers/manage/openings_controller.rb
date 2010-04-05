class Manage::OpeningsController < ApplicationController

  def index
    @title = "manage my openings"
    current_user.settings.update_attribute(:recruit_mode, 1)
    @user = current_user
  end
  
  def new
    @title = "New job opening"
    @contract = Contract.new
  end
  
  def create
    begin
      @contract = Contract.new(params[:contract])
      @contract.posted_by_user_id = current_user.id
      @contract.save!
      
      render :json => {:url => "/manage/openings"}.to_json, :status => 201
    rescue Exception => e
      render :json => collect_errors_for(@contract).to_json, :status => 406
    end
  end

  def edit
    @opening = Contract.find(params[:id])
    @organization = @opening.position.organization
  end
  
  def update
    begin
      @contract = Contract.find(params[:id])
      @contract.update_attributes(params[:contract])
      @contract.posted_by_user_id = current_user.id
      @contract.save!
      
      render :json => {:url => "/manage/openings"}.to_json, :status => 201
    rescue Exception => e
      render :json => collect_errors_for(@contract).to_json, :status => 406
    end
  end
  
  private
  
  def _find_or_create_position(organization, params)
    if params[:id].blank?
      position = Position.new(params)
      position.save!
      organization.positions << position
    else
      position = Position.find(params[:id])
    end
    position
  end

end