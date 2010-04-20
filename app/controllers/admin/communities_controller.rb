class Admin::CommunitiesController < AdminController
  
  def index
    @communities = Community.all
  end
  
  def new
    @html_content = render_to_string :partial => "/admin/communities/new.haml"
    respond_to do |format|
      format.js { render :template => "/common/new.rjs"}
    end
  end
  
  def create
    begin
      @community = Community.new(:name => params[:community][:name])
      @community.save!
      render :json => {:url => "/admin/communities"}.to_json, :status => 201
    rescue
      render :json => collect_errors_for(@community).to_json, :status => 406
    end
  end
  
  def edit
    @community = Community.find(params[:id])
    @html_content = render_to_string :partial => "/admin/communities/edit.haml"
    respond_to do |format|
      format.js { render :template => "/common/edit.rjs"}
    end
  end
  
  def update
    begin
      @community = Community.find(params[:id])
      @community.update_attributes(params[:community])
      @community.save!
      render :json => {:url => "/admin/communities"}.to_json, :status => 201
    rescue
      render :json => collect_errors_for(@community).to_json, :status => 406
    end
  end
  
end