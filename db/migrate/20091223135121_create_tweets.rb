class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets, :id => false do |t|
      t.column :twitter_id, "BIGINT UNSIGNED NOT NULL, PRIMARY KEY(twitter_id)"
      t.integer :user_id
      t.string :text
      t.integer :truncated
      t.column :in_reply_to_status_id, "BIGINT UNSIGNED"
      t.column :in_reply_to_user_id, "BIGINT UNSIGNED"
      t.string :in_reply_to_screen_name
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :tweets
  end
end
