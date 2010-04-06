require 'open-uri'

class OrganizationsController < ApplicationController

  before_filter :check_authentication, :except => :show

  def show
    begin
      @organization = Organization.find_by_id_or_handle!(params[:id])
      
      if current_user.present?
        @title = @organization.name
        @crunchbase_info = _get_crunchbase_info(@organization)

        respond_to do |format|
          format.html do 
            Stats::OrganizationProfileView.create!({:organization_id => @organization.id, :viewer_id => current_user.id})
            render :template => "/organizations/show/user/profile.haml"
          end
          format.xml do
            render :xml => @organization.to_xml(:only => ['name', 'summary', 'industry', 'year_founded'], :include => [:industry]) 
          end
        end
      else
        @title = "#{@organization.name}'s Public Profile"

        respond_to do |format|
          format.html do 
            Stats::OrganizationProfileView.create!({:organization_id => @organization.id})
            render :template => "/organizations/show/public/profile.haml"
          end
          format.xml do
            render :xml => @organization.to_xml(:only => ['name', 'summary', 'industry', 'year_founded'], :include => [:industry]) 
          end
        end
      end
    rescue
      raise
      render_404
    end
  end

  def newsfeed
    begin
      @organization = Organization.find_by_id_or_handle!(params[:id])
      @title = @organization.name
      @crunchbase_info = _get_crunchbase_info(@organization)

      respond_to do |format|
        format.html do 
          Stats::OrganizationProfileView.create!({:organization_id => @organization.id, :viewer_id => current_user.id})
          render :template => "/organizations/show/user/newsfeed.haml"
        end
        format.xml do
          render :xml => @organization.to_xml(:only => ['name', 'summary', 'industry', 'year_founded'], :include => [:industry]) 
        end
      end
    rescue
      raise
      render_404
    end
    
  end
  
  private 
  
  def _get_crunchbase_info(organization)
    begin
      buffer = open(organization.crunchbase_url).read
      info = JSON.parse(buffer)
      return false unless info["funding_rounds"].size > 0      
      info
    rescue
      false
    end
  end
  
  public
  
  
  def edit
    @user = current_user
    @organization = Organization.find(params[:id])
    
    @html_content = render_to_string :partial => "/organizations/edit.haml"
    respond_to do |format|
      format.js { render :template => "/common/edit.rjs" }
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
        
        step = AchievementStep.find(6)
        current_user.steps << step unless current_user.following_organizations(true).size < 3 or current_user.steps.include?(step)

        format.json{ render :json => :ok }
      rescue
        # raise
        format.json{ render :json => {}, :status => 500 }
      end
    end
  end
  
  def unfollow
  end

end
