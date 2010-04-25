class AddCreatedByToCommunities < ActiveRecord::Migration
  def self.up
    add_column :communities, :handle, :string
    add_column :communities, :description, :text
    add_column :communities, :created_by_user_id, :integer, :default => 1
    add_column :communities, :created_at, :datetime
    add_column :communities, :updated_at, :datetime
    
    connection.execute("UPDATE communities SET handle = name")
  end

  def self.down
    remove_column :communities, :updated_at
    remove_column :communities, :created_at
    remove_column :communities, :created_by_user_id
    remove_column :communities, :description
    remove_column :communities, :handle
  end
end
