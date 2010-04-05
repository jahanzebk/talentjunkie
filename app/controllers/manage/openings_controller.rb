class Manage::OpeningsController < ApplicationController

  def index
    @title = "manage my openings"
    current_user.settings.update_attribute(:recruit_mode, 1)
    @user = current_user
  end
  
  def new
    @title = "New job opening"
    @opening = Opening.new
    @opening.build_position
    @opening.position.build_organization
  end
  
  def create
    begin
      ActiveRecord::Base.transaction do
        @opening = Opening.new(params[:opening])
        @opening.posted_by_user_id = current_user.id
        @opening.save!
        
        @opening.activate
      
        params[:communities_to_post_to].to_a.each do |community_id|
          community = Community.find(community_id)
          community.openings << @opening
        end
      end
      render :json => {:url => "/manage/openings"}.to_json, :status => 201
    rescue Exception => e
      raise
      render :json => collect_errors_for(@opening).to_json, :status => 406
    end
  end

  def edit
    @title = "Edit job opening"
    @opening = Opening.find(params[:id])
    @organization = @opening.position.organization
  end
  
  def update
    begin
      @opening = Opening.find(params[:id])
      @opening.update_attributes(params[:opening])
      @opening.posted_by_user_id = current_user.id
      @opening.save!
      
      render :json => {:url => "/manage/openings"}.to_json, :status => 201
    rescue Exception => e
      render :json => collect_errors_for(@opening).to_json, :status => 406
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