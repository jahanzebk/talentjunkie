class CreateCommunities < ActiveRecord::Migration
  def self.up
    create_table :communities do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :communities
  end
end
