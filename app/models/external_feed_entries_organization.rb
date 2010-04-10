class ExternalFeedEntriesOrganization < ActiveRecord::Base
  belongs_to :external_feed_entry
  belongs_to :organization
  
  def self.find_by_assoc(entry, organization)
    self.find_by_sql("SELECT * FROM external_feed_entries_organizations WHERE external_feed_entry_id = #{entry.id} AND organization_id = #{organization.id}").first
  end
end