class CreateExternalFeedEntriesCommunities < ActiveRecord::Migration
  def self.up
    create_table :external_feed_entries_communities, :id => false do |t|
      t.integer :external_feed_entry_id
      t.integer :community_id
      t.integer :publish_count, :default => 0
    end
  end

  def self.down
  end
end
