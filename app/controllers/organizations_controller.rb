class OrganizationsController < ApplicationController

  def show
    @organization = Organization.find(params[:id])
    @title = "#{@organization.name} Profile"
# current_user.belongs_to?(@organization)

    respond_to do |format|
      format.html { render :template => "/organizations/show.haml"}
      format.xml  { render :xml => @organization }
    end
  end

end
