class AddMonthFoundedToOrganization < ActiveRecord::Migration
  def self.up
    add_column :organizations, :month_founded, :integer
  end

  def self.down
    remove_column :organizations, :month_founded
  end
end
