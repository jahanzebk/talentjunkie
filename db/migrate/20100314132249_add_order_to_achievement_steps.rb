class AddOrderToAchievementSteps < ActiveRecord::Migration
  def self.up
    add_column :achievement_steps, :order, :integer, :default => 1
  end

  def self.down
    remove_column :achievement_steps, :order
  end
end
