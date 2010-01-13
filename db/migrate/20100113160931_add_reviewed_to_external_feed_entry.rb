class AddReviewedToExternalFeedEntry < ActiveRecord::Migration
  def self.up
    add_column :external_feed_entries, :reviewed, :integer, :default => 0
  end

  def self.down
    remove_column :external_feed_entries, :reviewed
  end
end
