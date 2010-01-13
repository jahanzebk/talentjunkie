class Admin::ExternalFeedsController < AdminController
  
  def index
    @external_feeds = ExternalFeed.all
  end
  
end