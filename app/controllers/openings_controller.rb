class OpeningsController < ApplicationController

  before_filter :check_authentication, :except => [:index, :show]
  
  def index
    @title = "jobs"
  end
  
  def show
    begin
      @opening = Contract.find(params[:id])
      @organization = @opening.position.organization
      
      #flickr = Flickr.new(FLICKR_CONFIG)
      #@photos = flickr.photos.search(:user_id => "38326373@N00", :tags => "mehldaus")
      
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