class AddDescriptionToAchievements < ActiveRecord::Migration
  def self.up
    add_column :achievements, :description, :text
  end

  def self.down
    remove_column :achievements, :description
  end
end
