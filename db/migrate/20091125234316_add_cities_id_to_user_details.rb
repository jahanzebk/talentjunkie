class AddCitiesIdToUserDetails < ActiveRecord::Migration
  def self.up
    add_column :user_details, :cities_id, :integer, :default => 2094941 # London, UK
  end

  def self.down
    remove_column :user_details, :cities_id
  end
end
