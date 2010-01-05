class OrganizationOfficesController < ApplicationController
  
  def index
    begin
      @organization = Organization.find_by_id_or_handle!(params[:organization_id])
      render :template => "/organizations/show/user/offices.haml"
    rescue
      raise
      render_404
    end
  end
  
  def new
    @organization = Organization.find(params[:organization_id])
    @html_content = render_to_string :partial => "/organization_offices/new.haml"
    respond_to do |format|
      format.js
    end
  end
  
  def create
    begin
      @organization = Organization.find(params[:organization_id])
      
      @city = City.find(params[:address][:city][:id])
      @address = Address.factory(params[:address], @city)
      @address.save!
      
      @organization_office = OrganizationOffice.new(:organization_id => @organization.id, :name => params[:organization_office][:name], :address_id => @address.id)
      @organization_office.save!
      
      render :json => {:url => organization_offices_path(@organization)}.to_json, :status => 201
    rescue ActiveRecord::RecordNotFound => e
      errors = {:address_city => [['name', "can't be blank"]]}
      render :json => errors.to_json, :status => 406
    rescue
      # raise collect_errors_for(@address, @organization_office).to_json.inspect
      render :json => collect_errors_for(@address, @organization_office).to_json, :status => 406
    end
  end
  
end