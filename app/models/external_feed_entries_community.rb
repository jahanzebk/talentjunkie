class ExternalFeedEntriesCommunity < ActiveRecord::Base
  belongs_to :external_feed_entry
  belongs_to :community

  def self.find_by_assoc(entry, community)
    self.find_by_sql("SELECT * FROM external_feed_entries_communities WHERE external_feed_entry_id = #{entry.id} AND community_id = #{community.id}").first
  end
end