class ContractsController < ApplicationController
  
  def show
    @contract = Contract.find(params[:id])
    @position = @contract.position
    @organization = @position.organization
  end
  
  def new
    @html_content = render_to_string :partial => "/contracts/new.haml"
    respond_to do |format|
      format.js
    end
  end
  
  def edit
    @contract = Contract.find(params[:id])
    @position = @contract.position
    @organization = @position.organization
    @html_content = render_to_string :partial => "/contracts/edit.haml"
    respond_to do |format|
      format.js
    end
  end  

  def update
    begin
      ActiveRecord::Base.transaction do
        @organization = _find_or_create_organization(params[:organization])
        @position = _find_or_create_position(@organization, params[:position])
        @position.organization = @organization
        @position.save!
        
        @contract = Contract.find(params[:contract][:id])
        @contract.position_id = @position.id
        
        @contract.from_month = params[:date][:from_month]
        @contract.from_year  = params[:date][:from_year]
        
        if params[:date][:current].blank?
          @contract.to_month = params[:date][:to_month]
          @contract.to_year = params[:date][:to_year]
        end
        
        @contract.save!
      end
    
      flash[:success] = 'Position was successfully updated.'
    rescue
      raise
      flash[:error] = 'There was an error updating the record.'
    end
    redirect_to :my_profile
  end
  
  def create
    begin
      ActiveRecord::Base.transaction do
        @organization = _find_or_create_organization(params[:organization])
        @position = _find_or_create_position(@organization, params[:position])
        
        @contract = Contract.new({:user_id => current_user.id, :position_id => @position.id})
        @contract.from_month = params[:date][:from_month]
        @contract.from_year  = params[:date][:from_year]
        
        if params[:date][:current].blank?
          @contract.to_month = params[:date][:to_month]
          @contract.to_year = params[:date][:to_year]
        end
        
        @contract.save!
      end
    
      flash[:success] = 'Position was successfully created.'
    rescue
      flash[:error] = 'There was an error creating the record.'
    end
    redirect_to :my_profile
  end  

  def destroy
    current_user.contracts.find(params[:id]).destroy
    redirect_to :my_profile
  end
  
  private
  
  def _find_or_create_organization(params)
    if params[:id].blank?
      organization = Organization.find_by_name(params[:name])
      unless organization
        organization = Organization.new(:name => params[:name])
        organization.save!
      end
    else
      organization = Organization.find(params[:id])
    end
    organization
  end
  
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