class DiplomasController < ApplicationController
  
  def new
    @html_content = render_to_string :partial => "/diplomas/new.haml"
    respond_to do |format|
      format.js
    end
  end
  
  def create
    begin
      ActiveRecord::Base.transaction do
        @organization = _find_or_create_organization(params[:organization])
        @degree = _find_or_create_degree(@organization, params[:degree])
        
        @diploma = Diploma.new
        @diploma.user_id = current_user.id
        @diploma.degree_id = @degree.id
        @diploma.from_month = params[:date][:from_month]
        @diploma.from_year  = params[:date][:from_year]
        
        if params[:date][:current].blank?
          @diploma.to_month = params[:date][:to_month]
          @diploma.to_year = params[:date][:to_year]
        end
        
        @diploma.save!
      end
      render :json => {:url => person_path(current_user)}.to_json, :status => 201
    rescue
      raise
      render :json => collect_errors_for(@organization, @degree, @diploma).to_json, :status => 406
    end
  end
  
  def edit
    @diploma = Diploma.find(params[:id])
    @html_content = render_to_string :partial => "/diplomas/edit.haml"
    respond_to do |format|
      format.js
    end
  end
  
  def update
    begin
      ActiveRecord::Base.transaction do
        @organization = _find_or_create_organization(params[:organization])
        @degree = _find_or_create_degree(@organization, params[:degree])
        
        @diploma = Diploma.find(params[:id])
        @diploma.degree_id = @degree.id
        @diploma.from_month = params[:date][:from_month]
        @diploma.from_year  = params[:date][:from_year]
        
        if params[:date][:current].blank?
          @diploma.to_month = params[:date][:to_month]
          @diploma.to_year = params[:date][:to_year]
        else
          @diploma.to_month = nil
          @diploma.to_year = nil
        end
        
        @diploma.save!
      end
      render :json => {:url => person_path(current_user)}.to_json, :status => 201
    rescue
      render :json => collect_errors_for(@organization, @degree, @diploma).to_json, :status => 406
    end
  end
  
  def destroy
    current_user.diplomas.find(params[:id]).destroy
    redirect_to person_path(current_user)
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
  
  def _find_or_create_degree(organization, params)
    if params[:id].blank?
      @degree = Degree.new(params)
      @degree.organization_id = organization.id
      @degree.save!
    else
      @degree = Degree.find(params[:id])
    end
    @degree
  end
end