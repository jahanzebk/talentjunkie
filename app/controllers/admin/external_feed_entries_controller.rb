class Admin::ExternalFeedEntriesController < AdminController
  
  def index
    @external_feed = ExternalFeed.find(params[:external_feed_id])
    @entries = @external_feed.entries.not_reviewed
  end

  def publish_to_all
    begin
      @entry = ExternalFeedEntry.find(params[:id])
      ActiveRecord::Base.transaction do
        @entry.organizations.each do |organization|
          ActiveRecord::Base.connection.execute("UPDATE external_feed_entries_organizations SET publish_count = publish_count + 1 WHERE external_feed_entry_id = #{@entry.id} AND organization_id = #{organization.id}")
          Events::PostPublished.create!({:object_id => organization.id, :subject_id => @entry.id})
        end
      end
      redirect_to admin_external_feed_entries_path(@entry.external_feed)
    rescue
      raise
    end
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