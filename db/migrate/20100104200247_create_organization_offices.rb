class CreateOrganizationOffices < ActiveRecord::Migration
  def self.up
    create_table :organization_offices do |t|
      t.integer :organization_id
      t.integer :address_id
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :organization_offices
  end
end
