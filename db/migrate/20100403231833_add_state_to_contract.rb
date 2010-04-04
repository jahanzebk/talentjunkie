class AddStateToContract < ActiveRecord::Migration
  def self.up
    add_column :contracts, :state, :integer, :default => 0
  end

  def self.down
    remove_column :contracts, :state
  end
end
