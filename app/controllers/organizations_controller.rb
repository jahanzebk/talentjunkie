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

  def follow
    respond_to do |format|
      begin
        @organization = Organization.find(params[:id])
        FollowingOrganization.create!({:user_id => current_user.id, :organization_id => @organization.id}) unless current_user.is_following_organization?(@organization)
        format.json{ render :json => :ok }
      rescue
        raise
        format.json{ render :json => {}, :status => 500 }
      end
    end
  end
  
  def unfollow
  end

end
