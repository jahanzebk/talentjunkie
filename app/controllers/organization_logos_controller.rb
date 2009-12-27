class OrganizationLogosController < ApplicationController
  
  def new
    @organization = Organization.find(params[:organization_id])
    @html_content = render_to_string :partial => "/organizations/logo.haml"
    respond_to do |format|
      format.js {render :template => "/organizations/logo.rjs"}
    end
  end
  
  def create
    @organization = Organization.find(params[:organization_id])
    logo = OrganizationLogo.new(params[:organization_logo])
    logo.uploaded_on = Time.now
    logo.uploaded_by_user_id = current_user.id
    
    flash[:success] = 'Logo was successfully uploaded' if logo.save!
  
    @organization.logo.destroy if @organization.logo
    @organization.logo = logo
    
    redirect_to organization_path(@organization)
  end
  
  def destroy
    @organization = Organization.find(params[:organization_id])
    @organization.logo.destroy
    redirect_to organization_path(@organization)
  end
end