class Manage::OpeningsController < ApplicationController
  
  def index
    @title = "manage my openings"
    current_user.settings.update_attribute(:recruit_mode ,1)
    @user = current_user
  end
  
  def new
    @organization = Organization.find(params[:organization_id])
    @title = "New job opening at #{@organization.name}"
  end
  
  def create
    @organization = Organization.find(params[:organization_id])
    begin
      ActiveRecord::Base.transaction do
        if params[:position][:id].blank?
          @position = @organization.positions.find_by_title(params[:position][:title])
          unless @position
            @position = Position.new(params[:position])
            @position.save!
            @organization.positions << @position
          end
        else
          @position = Position.find(params[:position][:id])
        end
        
        @contract = Contract.new(params[:contract])
        @contract.position_id = @position.id
        
        if params[:date][:asap].blank?
          @contract.from = params[:date][:from_year], params[:date][:from_month]
        end
        
        if params[:date][:open].blank?
          @contract.to = params[:date][:to_year], params[:date][:to_month]
        end
        
        @contract.posted_by_user_id = current_user.id
        @contract.save!
      end
      
      Events::NewOpening.create!({:subject_id => @organization.id, :object_id => @contract.id})
      
      JobApplicationStage.create!({:contract_id => @contract.id, :name => "New", :label => "N", :order => 1})
      JobApplicationStage.create!({:contract_id => @contract.id, :name => "Interview", :label => "I", :order => 2})
      JobApplicationStage.create!({:contract_id => @contract.id, :name => "Offers & Hires", :label => "I", :order => 3})
      
      flash[:success] = 'Opening was successfully created.'
      redirect_to "/manage/openings"
    rescue
      render :template => "/manage/openings/new.haml"
    end
  end  

  def edit
    @opening = Contract.find(params[:id])
    @organization = @opening.position.organization
  end
  
  def update
    begin
      ActiveRecord::Base.transaction do
        @organization = Organization.find(params[:organization_id])
        @position = _find_or_create_position(@organization, params[:position])
        
        @contract = Contract.find(params[:id])
        @contract.position_id = @position.id
        
        @contract.attributes = params[:contract]
        # @contract.description = params[:contract][:description]
        # @contract.benefits = params[:contract][:benefits]
        
        if params[:date][:asap].blank?
          @contract.from = params[:date][:from_year], params[:date][:from_month]
        else
          @contract.from = nil
        end
        
        if params[:date][:open].blank?
          @contract.to = params[:date][:to_year], params[:date][:to_month]
        else
          @contract.to = nil
        end
        
        @contract.posted_by_user_id = current_user.id
        @contract.save!
      end
    
      flash[:success] = 'Opening was successfully updated.'
      redirect_to "/manage/openings"
    rescue
      raise
      render :template => "/manage/openings/edit.haml"
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