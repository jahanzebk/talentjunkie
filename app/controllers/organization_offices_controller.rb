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
end