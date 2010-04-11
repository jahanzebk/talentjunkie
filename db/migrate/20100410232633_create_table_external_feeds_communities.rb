class CreateTableExternalFeedsCommunities < ActiveRecord::Migration
  def self.up
    create_table :external_feeds_communities do |t|
      t.integer :external_feed_id
      t.integer :community_id
      t.boolean :auto_publish
    end
  end

  def self.down
    drop_table :external_feeds_communities
  end
end
