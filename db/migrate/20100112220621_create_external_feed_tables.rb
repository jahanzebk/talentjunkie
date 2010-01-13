class CreateExternalFeedTables < ActiveRecord::Migration
  def self.up
    create_table :external_feeds do |t|
      t.string :title
      t.string :url
      t.string :feed_url
      t.string :etag
      t.datetime :last_modified
    end
    
    create_table :external_feed_entries do |t|
      t.integer :external_feed_id
      t.string :guid
      t.string :title
      t.string :url
      t.string :author
      t.text :summary
      t.text :content
      t.datetime :published
      t.integer :classified, :default => 0
    end
    
    create_table :external_feed_entries_organizations, :id => false do |t|
      t.integer :external_feed_entry_id
      t.integer :organization_id
      t.integer :publish_count, :default => 0
    end
  end

  def self.down
    drop_table :external_feed_entries_organizations
    drop_table :external_feed_entries
    drop_table :external_feeds
  end
end
