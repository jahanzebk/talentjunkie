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
  
  def edit
    @user = current_user
    
    @organization = Organization.find(params[:id])
    
    @html_content = render_to_string :partial => "/organizations/edit.haml"
    respond_to do |format|
      format.js
    end
  end
  
  def update
      begin
        @organization = Organization.find(params[:id])
        # raise SecurityError unless current_user.belongs_to?(@organization)

        @organization.summary = params[:organization][:summary]
        @organization.save!
      
        render :json => {:url => "/organizations/#{@organization.id}"}.to_json, :status => 201
      rescue
        raise
        render :json => collect_errors_for(@organization).to_json, :status => 406
      end
  end

  def follow
    respond_to do |format|
      begin
        @organization = Organization.find(params[:id])
        FollowingOrganization.create!({:user_id => current_user.id, :organization_id => @organization.id}) unless current_user.is_following_organization?(@organization)
        
        Events::StartFollowingOrganizations.create!({:subject_id => current_user.id, :object_id => @organization.id})
        
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
