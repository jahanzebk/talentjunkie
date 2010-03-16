class UpdateHandlesForUsersWithoutHandles < ActiveRecord::Migration
  def self.up
    
    add_column :users, :is_default_handle, :boolean, :default => true
    
    User.all(:conditions => "handle IS NOT NULL").each do |user|
      user.is_default_handle = false
      user.save!
    end
    
    User.all(:conditions => "handle IS NULL").each do |user|
      user.handle = "a#{UUIDTools::UUID.timestamp_create}"
      user.save!
    end
  end

  def self.down
    remove_column :users, :is_default_handle
  end
end
