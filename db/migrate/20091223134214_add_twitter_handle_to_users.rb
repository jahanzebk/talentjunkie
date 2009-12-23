class AddTwitterHandleToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter_handle, :string
  end

  def self.down
    remove_column :users, :twitter_handle
  end
end
