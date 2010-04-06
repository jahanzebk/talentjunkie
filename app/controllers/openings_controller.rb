class OpeningsController < ApplicationController

  before_filter :check_authentication, :except => [:index, :show]
  
  def index
    @title = "jobs"
    @openings = Opening.active
  end
  
  def show
    begin
      @opening = Opening.find(params[:id])
      @organization = @opening.position.organization
      
      @title = "#{@opening.position.title} at #{@organization.name}"
      
      #flickr = Flickr.new(FLICKR_CONFIG)
      #@photos = flickr.photos.search(:user_id => "38326373@N00", :tags => "mehldaus")
      
      if current_user.present?
        Stats::OpeningView.create!({:viewer_id => current_user.id, :opening_id => @opening.id}) unless current_user == @opening.posted_by
      else
        Stats::OpeningView.create!({:opening_id => @opening.id})
      end
      
      if current_user.present?
        render :template => "/openings/show/user/show.haml"
      else
        render :template => "/openings/show/public/show.haml"
      end
    rescue
      raise
      render_404
    end
  end
  
end