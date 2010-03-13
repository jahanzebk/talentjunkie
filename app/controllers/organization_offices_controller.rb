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
      format.js { render :template => "/common/new.rjs"}
    end
  end
  
  def edit
    @organization_office = OrganizationOffice.find(params[:id])
    @html_content = render_to_string :partial => "/organization_offices/edit.haml"
    respond_to do |format|
      format.js { render :template => "/common/edit.rjs"}
    end
  end
  
  def create
    begin
      @organization = Organization.find(params[:organization_id])
      
      ActiveRecord::Base.transaction do
        @city = City.find(params[:address][:city][:id])
        @address = Address.factory(params[:address], @city)
        @address.save!
      
        @organization_office = OrganizationOffice.new(:organization_id => @organization.id, :name => params[:organization_office][:name], :address_id => @address.id)
        @organization_office.save!
      end
      
      render :json => {:url => organization_offices_path(@organization)}.to_json, :status => 201
    rescue ActiveRecord::RecordNotFound => e
      errors = {:address_city => [['name', "can't be blank"]]}
      render :json => errors.to_json, :status => 406
    rescue
      # raise collect_errors_for(@address, @organization_office).to_json.inspect
      render :json => collect_errors_for(@address, @organization_office).to_json, :status => 406
    end
  end
  
  
  def update
    begin
      ActiveRecord::Base.transaction do
        @organization_office = OrganizationOffice.find(params[:id])
        @organization_office.name = params[:organization_office][:name]
        @organization_office.save!
        
        @city = City.find(params[:address][:city][:id])
        
        @address = @organization_office.address
        @address.address_1 = params[:address][:address_1]
        @address.address_2 = params[:address][:address_2]
        @address.postal_code = params[:address][:postal_code]
        @address.city_id = @city.id
        @address.save!
      end      
      
      render :json => {:url => organization_offices_path(@organization_office.organization)}.to_json, :status => 201
    rescue ActiveRecord::RecordNotFound => e
      errors = {:address_city => [['name', "can't be blank"]]}
      render :json => errors.to_json, :status => 406
    rescue
      # raise collect_errors_for(@address, @organization_office).to_json.inspect
      render :json => collect_errors_for(@address, @organization_office).to_json, :status => 406
    end
  end

  def destroy
    organization = Organization.find(params[:organization_id])
    organization.offices.find(params[:id]).destroy
    redirect_to organization_offices_path(organization)
  end

end