class DiplomasController < ApplicationController
  def new
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
        
        if params[:degree][:id].blank?
          @degree = Degree.new(params[:degree])
          @degree.save!
          @organization.degrees << @degree
        else
          @degree= Degree.find(params[:degree][:id])
        end
        
        @diploma = Diploma.new
        @diploma.user_id = current_user
        @diploma.degree_id = @degree.id
        @diploma.from_month = params[:date][:from_month]
        @diploma.from_year  = params[:date][:from_year]
        
        if params[:date][:current].blank?
          @diploma.to_month = params[:date][:to_month]
          @diploma.to_year = params[:date][:to_year]
        end
        
        @diploma.save!
      end
    
      flash[:notice] = 'Degree was succesfully created.'
      
      redirect_to(profile_path)
    rescue
      raise
      render :template => "/degrees/new.haml"
    end
  end
end