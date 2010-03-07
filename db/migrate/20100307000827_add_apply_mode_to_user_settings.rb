class AddApplyModeToUserSettings < ActiveRecord::Migration
  def self.up
    add_column :user_settings, :apply_mode, :integer, :default => 0
  end

  def self.down
    remove_column :user_settings, :apply_mode
  end
end
