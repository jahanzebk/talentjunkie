class AddThemeIdToCommunities < ActiveRecord::Migration
  def self.up
    add_column :communities, :theme_id, :integer, :default => 1
  end

  def self.down
    remove_column :communities, :theme_id
  end
end
