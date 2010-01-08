class CreateTableUserThemes < ActiveRecord::Migration
  def self.up
    create_table :user_themes do |t|
      t.integer :user_id
      t.string :header_foreground_color
      t.string :header_background_color
      t.string :header_background
    end
  end

  def self.down
    drop_table :user_themes
  end
end
