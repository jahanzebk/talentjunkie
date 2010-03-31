class AddThemeIdToUserSettings < ActiveRecord::Migration
  def self.up
    add_column :user_settings, :theme_id, :integer, :default => 1
    drop_table :user_themes
  end

  def self.down
    create_table :user_themes do |t|
      t.integer :user_id
      t.string :header_foreground_color
      t.string :header_background_color
      t.string :header_background
    end
    remove_column :user_settings, :theme_id
  end
end
