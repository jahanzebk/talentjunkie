class OrganizationsController < ApplicationController

  before_filter :check_authentication, :except => :show

  def show
    begin
      current_user.present? ? _profile_with_logged_in_user : _public_profile
    rescue
      raise
      render_404
    end
  end

  private
  
  def _public_profile
    @organization = Organization.find_by_id_or_handle!(params[:id])
    @title = "#{@organization.name}'s Public Profile"

    respond_to do |format|
      format.html do 
        Stats::OrganizationProfileView.create!({:organization_id => @organization.id})
        render :template => "/organizations/show/public_profile.haml"
      end
      format.xml do
        render :xml => @organization.to_xml(:only=> ['name', 'summary', 'industry', 'year_founded'], :include => [:industry]) 
      end
    end
  end

  def _profile_with_logged_in_user
    @organization = Organization.find_by_id_or_handle!(params[:id])
    @title = @organization.name

    respond_to do |format|
      format.html do 
        Stats::OrganizationProfileView.create!({:organization_id => @organization.id, :viewer_id => current_user.id})
        render :template => "/organizations/show/profile.haml"
      end
      format.xml do
        render :xml => @organization.to_xml(:only=> ['name', 'summary', 'industry', 'year_founded'], :include => [:industry]) 
      end
    end
  end
  
  public
  
  
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
        @organization.website = params[:organization][:website ]
        @organization.blog = params[:organization][:blog]
        @organization.twitter_handle = params[:organization][:twitter_handle]
        @organization.save!
      
        render :json => {:url => organization_path(@organization)}.to_json, :status => 201
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
