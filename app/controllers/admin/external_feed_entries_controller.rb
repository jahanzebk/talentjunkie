class Admin::ExternalFeedEntriesController < AdminController
  
  def index
    @external_feed = ExternalFeed.find(params[:external_feed_id])
    @entries = @external_feed.entries.not_classified
  end
  

  def review
    begin
      @entry = ExternalFeedEntry.find(params[:id])
      @entry.update_attribute(:reviewed, 1)
      redirect_to admin_external_feed_entries_path(@entry.external_feed)
    rescue
      raise
    end
  end  
  
  def unreview
    begin
      @entry = ExternalFeedEntry.find(params[:id])
      @entry.update_attribute(:reviewed, 0)
      redirect_to admin_external_feed_entries_path(@entry.external_feed)
    rescue
      raise
    end
  end
end