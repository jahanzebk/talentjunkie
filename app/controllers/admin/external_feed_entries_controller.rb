class Admin::ExternalFeedEntriesController < AdminController
  
  def index
    @external_feed = ExternalFeed.find(params[:external_feed_id])
    @entries = @external_feed.entries.not_reviewed
  end
  
  def show
    @entry = ExternalFeedEntry.find(params[:id])
    
    @organization_json_template = render_to_string :partial => 'admin/external_feed_entries/organization.json.haml'
    @organization_json_template.gsub!(/["]/, '\\"') unless @organization_json_template.blank?
    @organization_json_template.gsub!(/[\n]/,'') unless @organization_json_template.blank?

    @community_json_template = render_to_string :partial => 'admin/external_feed_entries/community.json.haml'
    @community_json_template.gsub!(/["]/, '\\"') unless @community_json_template.blank?
    @community_json_template.gsub!(/[\n]/,'') unless @community_json_template.blank?
  end

  def publish_to_all
    begin
      @entry = ExternalFeedEntry.find(params[:id])
      ActiveRecord::Base.transaction do
        @entry.organizations.each do |organization|
          ActiveRecord::Base.connection.execute("UPDATE external_feed_entries_organizations SET publish_count = publish_count + 1 WHERE external_feed_entry_id = #{@entry.id} AND organization_id = #{organization.id}")
          Events::PostPublished.create!({:object_id => organization.id, :subject_id => @entry.id})
        end
        @entry.update_attribute(:reviewed, 1)
      end
     render :json => {}, :status => 201
    rescue
      render :json => {}, :status => 406
    end
  end
  

  def review
    begin
      @entry = ExternalFeedEntry.find(params[:id])
      @entry.update_attribute(:reviewed, 1)
      render :json => {}, :status => 201
    rescue
      render :json => {}, :status => 406
    end
  end  
  
  def unreview
    begin
      @entry = ExternalFeedEntry.find(params[:id])
      @entry.update_attribute(:reviewed, 0)
      render :json => {}, :status => 201
    rescue
      render :json => {}, :status => 406
    end
  end
end