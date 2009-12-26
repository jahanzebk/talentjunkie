class CreateProfileViews < ActiveRecord::Migration
  def self.up
    create_table :profile_views, :id => false do |t|
      t.integer :viewer_id
      t.integer :user_id
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :profile_views
  end
end
