class RenameContractCitiesIdToCityId < ActiveRecord::Migration
  def self.up
    rename_column :contracts, :cities_id, :city_id
  end

  def self.down
    rename_column :contracts, :city_id, :cities_id
  end
end
