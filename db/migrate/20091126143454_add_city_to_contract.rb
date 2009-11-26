class AddCityToContract < ActiveRecord::Migration
  def self.up
    add_column :contracts, :cities_id, :integer, :default => 2094941 # London, UK
  end

  def self.down
    remove_column :contracts, :cities_id
  end
end
