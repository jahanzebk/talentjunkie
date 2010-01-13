class Admin::ExternalFeedEntriesController < AdminController
  
  def index
    @external_feed = ExternalFeed.find(params[:external_feed_id])
    @entries = @external_feed.entries.not_classified
  end
  

  def classify
    begin
      @entry = ExternalFeedEntry.find(params[:id])
      @entry.update_attribute(:classified, 1)
      redirect_to admin_external_feed_entries_path(@entry.external_feed)
    rescue
      raise
    end
  end  
  
  def unclassify
    begin
      @entry = ExternalFeedEntry.find(params[:id])
      @entry.update_attribute(:classified, 0)
      redirect_to admin_external_feed_entries_path(@entry.external_feed)
    rescue
      raise
    end
  end
end