class OpeningsController < ApplicationController
  
  def show
  end
  
  def new
    @organization = Organization.find(params[:organization_id])
    @title = "New job opening at #{@organization.name}"
    render :template => "/openings/new.haml"
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
        @contract.position_id = @position
        
        if params[:date][:asap].blank?
          @contract.from_month = params[:date][:from_month]
          @contract.from_year = params[:date][:from_year]
        end
        
        if params[:date][:open].blank?
          @contract.to_month = params[:date][:to_month]
          @contract.to_year = params[:date][:to_year]
        end
        
        @contract.posted_by_user_id = current_user.id
        
        @contract.save!
      end
    
      flash[:notice] = 'Opening was successfully created.'
      
      redirect_to(organization_path(@organization))
    rescue
      raise
      render :template => "/openings/new.haml"
    end
  end  
end