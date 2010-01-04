class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :type
      t.string :address_1
      t.string :address_2
      t.string :postal_code
      t.integer :city_id
      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
