class Admin::OrganizationsController < AdminController
  
  def index
    @starting_with = params[:q] ? params[:q] : 'a'
    @organizations = Organization.all(:conditions => "name LIKE '#{@starting_with}%'", :order => "name ASC")
  end

  def new
    @html_content = render_to_string :partial => "/admin/organizations/new.haml"
    respond_to do |format|
      format.js
    end
  end
  
  def create
    begin
      @organization = Organization.new(:name => params[:organization][:name], :industry_id => params[:organization][:industry_id])
      @organization.save!
      render :json => {:url => "/admin/organizations/?q=#{@organization.name[0,1]}"}.to_json, :status => 201
    rescue
      render :json => collect_errors_for(@organization).to_json, :status => 406
    end
  end
  
  def edit
    @organization = Organization.find(params[:id])
    @html_content = render_to_string :partial => "/admin/organizations/edit.haml"
    respond_to do |format|
      format.js
    end
  end
  
  def update
    begin
      @organization = Organization.find(params[:id])
      @organization.name = params[:organization][:name]
      @organization.industry_id = params[:organization][:industry_id]
      @organization.save!
      render :json => {:url => "/admin/organizations/?q=#{@organization.name[0,1]}"}.to_json, :status => 201
    rescue
      raise
      render :json => collect_errors_for(@organization).to_json, :status => 406
    end
  end
end