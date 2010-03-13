class CreateOpeningViews < ActiveRecord::Migration
  def self.up
    create_table :opening_views, :id => false do |t|
      t.integer :viewer_id
      t.integer :opening_id
      t.timestamp :created_at
    end
  end

  def self.down
    drop_table :opening_views
  end
end
