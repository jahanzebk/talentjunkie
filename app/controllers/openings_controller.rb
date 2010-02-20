class OpeningsController < ApplicationController

  def index
  end
  
  def show
    begin
      @opening = Contract.find(params[:id])
      @organization = @opening.position.organization
      
      #flickr = Flickr.new(FLICKR_CONFIG)
      #@photos = flickr.photos.search(:user_id => "38326373@N00", :tags => "mehldaus")
    rescue
      raise
      render_404
    end
  end
  
end