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
  
  def create
    begin
      ActiveRecord::Base.transaction do
        @organization = _find_or_create_organization(params[:organization])
        @position = _find_or_create_position(@organization, params[:position])
        
        @contract = Contract.new({:user_id => current_user.id, :position_id => @position.id, :description => params[:contract][:description]})
        @contract.cities_id = params[:contract][:city][:id]
        
        @contract.from_month = params[:contract][:from_month]
        @contract.from_year  = params[:contract][:from_year]
        
        if params[:contract][:current].blank?
          @contract.to_month = params[:contract][:to_month]
          @contract.to_year = params[:contract][:to_year]
        end
        
        @contract.save!
      end
    
      render :json => {:url => "/my/profile"}.to_json, :status => 201
    rescue
      render :json => collect_errors_for(@organization, @position, @contract).to_json, :status => 406
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
        @contract.description = params[:contract][:description]
        @contract.cities_id = params[:contract][:city][:id]
                
        @contract.from_month = params[:contract][:from_month]
        @contract.from_year  = params[:contract][:from_year]
        
        if params[:contract][:current].blank?
          @contract.to_month = params[:contract][:to_month]
          @contract.to_year = params[:contract][:to_year]
        end
        
        @contract.save!
      end
      render :json => {:url => "/my/profile"}.to_json, :status => 201
    rescue
      render :json => collect_errors_for(@organization, @position, @contract).to_json, :status => 406
    end
  end
  
  def destroy
    current_user.contracts.find(params[:id]).destroy
    redirect_to :my_profile
  end
  
  private
  
  def _find_or_create_organization(params)
    if params[:id].blank?
      @organization = Organization.find_by_name(params[:name])
      unless @organization
        @organization = Organization.new(:name => params[:name])
        @organization.save!
      end
    else
      @organization = Organization.find(params[:id])
    end
    @organization
  end
  
  def _find_or_create_position(organization, params)
    if params[:id].blank?
      @position = Position.new(params)
      @position.save!
      @organization.positions << @position
    else
      @position = Position.find(params[:id])
    end
    @position
  end
end