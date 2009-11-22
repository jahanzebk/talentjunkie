class ContractsController < ApplicationController
  
  def show
    @contract = Contract.find(params[:id])
    @position = @contract.position
    @organization = @position.organization
  end
  
  def new
    render :template => "/contracts/new.haml"
  end
  
  def create
    begin
      ActiveRecord::Base.transaction do
        if params[:organization][:id].blank?
          @organization = Organization.find_by_name(params[:organization][:name])
          unless @organization
            @organization = Organization.new(:name => params[:organization][:name])
            @organization.save!
          end
        else
          @organization = Organization.find(params[:organization][:id])
        end
        
        if params[:position][:id].blank?
          @position = Position.new(params[:position])
          @position.save!
          @organization.positions << @position
        else
          @position = Position.find(params[:position][:id])
        end
        
        @contract = Contract.new({:user_id => current_user.id, :position_id => @position.id})
        @contract.from_month = params[:date][:from_month]
        @contract.from_year  = params[:date][:from_year]
        
        if params[:date][:current].blank?
          @contract.to_month = params[:date][:to_month]
          @contract.to_year = params[:date][:to_year]
        end
        
        @contract.save!
      end
    
      flash[:notice] = 'Position was successfully created.'
      
      redirect_to(my_profile_path)
    rescue
      raise
      render :template => "/contracts/new.haml"
    end
  end  

  def destroy
    current_user.contracts.find(params[:id]).destroy
    redirect_to :my_profile
  end
end