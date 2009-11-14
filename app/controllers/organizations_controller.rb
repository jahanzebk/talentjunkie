class OrganizationsController < ApplicationController
  def show
    @organization = Organization.find(params[:id])
    @title = "#{@organization.name} Profile"

    if current_user.belongs_to?(@organization)
      respond_to do |format|
        format.html { render :template => "/organizations/show_for_employee.haml"}
        format.xml  { render :xml => @organization }
      end
    else
      respond_to do |format|
        format.html { render :template => "/organizations/show_for_others.haml"}
        format.xml  { render :xml => @organization }
      end
    end
  end

  def new
    @organization = Organization.new
  end
  
  def create
    begin
      @organization = Organization.create!(params[:organization])
      flash[:notice] = 'Organization was successfully created.'
      redirect_to organizations_path
    rescue
      flash[:notice] = 'Organization not created because it already existed.'
      redirect_to organizations_path
    end
  end

end
