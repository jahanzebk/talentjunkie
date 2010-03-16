class CreateGuidesUsers < ActiveRecord::Migration
  def self.up
    
    add_column :guides, :id, :primary_key
    
    create_table :guides_users, :id => false do |t|
      t.integer :guide_id
      t.integer :user_id
    end
  end

  def self.down
    remove_column :guides, :id
    drop_table :guides_users
  end
end
